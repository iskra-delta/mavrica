# mavrica

The JIT ZX Spectrum emulator for the Iskra Delta Partner.

# How does it work?

Don't know yet. 

This is an experiment that uses just-in-time interpretation to implement a pseudo user-mode for the Z80 microprocessor that lacks separation of user and kernel modes. 

 > **Disclaimer!** This is an experiment under development. There are known unknowns and unknown unknowns on its path. We will make necessary corrections as we discover new facts. If you are reading this in the middle of the experiment, don't assume we know what we're doing. 

# What is the goal?

To gain *supervisor like* control over executed program on a Z80 microprocessor. The experiment is divided into four phases. **We are at phase I.** 

In **phase I.** we will gain control over all jumps in the program. In **phase II.** we will redirect all port reads and writes to our handlers. In **phase III.** we will hook memory read and write operations. And, finally, in **phase IV.** we will handle interrupts.

# Phase I. Taking control of the jumps

The *JITI* (Just In Time Interpreter) installs the *RST8 handler* so that every time the `RST8` instruction is executed, it hands the reins over to our handler.

The *JITI* then loads the *Z80* program to a provided load address and starts interpreting it at provided start address. It extracts the first "basic block" from the program by seeking for the first branch (`jp`, `jr`, `ret`, `djnz`, etc.) instruction.  

Once it is found, its' first byte is replaced by the `RST8` call, and it is stored to a list of basic blocks. 

Finally, a jump to the start address is executed yielding control to the *Z80* program we are interpreting.

The program will execute until it hits the `RST8` instruction. At that point it will hand the control over to our *RST8 handler*. The handler will pick the address from the stack and search for it in the list of basic blocks. If found, then this block has already been compiled. In this case it will rewrite the `RST8` instruction with its original contents and jump to it continuing the program execution. 

 > The handler will always make sure no conditions (registers, flags) are affected.

However if the basic block is not found, it will repeat the compilation process. It will compile the new block starting with target of the jump and ending with a branch instruction. And then jump to it. Eventually every basic block of the program will be compiled, and the program will run at almost native speed. The only instructions not compiled will be dynamic jumps (`jp (hl)`, `jp(ix)`, `jp(iy)`).

 > Neighbouring basic blocks will be merged to minimize allocated memory.

 ## Decoding Z80 instructions

 In phase I. we are interested in two aspects of every instruction. First is the instruction length, and second is identifying jumps. To minimize the effort of decoding the instruction we are going to use [tricks collected by Christian Dinu from various sources](http://www.z80.info/decoding.htm). Following is a final state machine that does the job.


 On this figure, squares are identified jump operations and transitions may have /+n postfix, which is the number of bytes to proceed. Hence if the first byte of our program is `0xE9` then we move one byte ahead and identify the instruction as `JP (HL)`. If the first byte is `0xCB` then we move ahead two bytes (as all instructions starting with `0xCB` are two bytes long), and we don't recognize a jump (because there are no jump instructions starting with `0xCB`). The pattern i.e. `01***011` is pseudo regular expression for a bitmask of the observed byte where the value of asterisk can be 0 or 1.