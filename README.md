# HOMER
HOMER is an HOMEmade processoR with a custom 16-bit instruction set. The idea is to have fun with hardware processor development. An UART should be proposed as well.

This is mainly based on the tutorial available at: http://labs.domipheus.com/blog/category/projects/tpu/

## Instruction set and decoding

Here is the basic instruction format :

| Instruction        | 15-12    | 11-8      | 7-4        | 3-0        |
| ------------------ | -------- | --------- | ---------- | ---------- |
| RRR (i.e. `ADD`)   | `opcode` | `reg_dst` | `reg_src1` | `reg_src2` |
| Rrd (i.e. `NOT`)   | `opcode` | `reg_dst` | `reg_src1` | unused     |
| RImm (i.e. `LOAD`) | `opcode` | `reg_dst` | `Imm(7-4)` | `Imm(3-0)` |

### Opcodes

| Opcode | Instruction     | Implemented and validated |
| ------ | --------------- | ------------------------- |
| 0000   | ADD             | Done                      |
| 0001   | SUB             |                           |
| 0010   | OR              | Done                      |
| 0011   | XOR             | Done                      |
| 0100   | AND             | Done                      |
| 0101   | NOT             | Done                      |
| 0110   | Read            |                           |
| 0111   | Write           |                           |
| 1000   | Load            | Done                      |
| 1001   | Compare         | Done                      |
| 1010   | Shift L         | Done                      |
| 1011   | Shift R         | Done                      |
| 1100   | Jump            |                           |
| 1101   | Jump conditonal |                           |
| 1110   | -               |                           |
| 1111   | -               |                           |

## 24/06/2020

![sche](./img/homer_schematic.png)

**First  (buggy) version of Homer !**

<<<<<<< HEAD
![img](./img/homer_screen1.png)
- The 1st instruction is decoded/executed in 4 cycles.
- Next instruction to be executed is the 5th one:
  - Due to the FSM, the instruction decoder is enabled every 4 cycles.
  - While other instructions are being read from the code memory, the current instruction is processed by Homer.
  - The result of the current instruction is written in the register file 3 cycles after decoding (i.e. when `state=2` or `state=8`).
=======
- In the simulation, the first instruction being decoded is the 4th stored in the RAM (`LOAD 1,MSB(R7)`)
  - Takes 4 cycles for being decoded/executed.
  - At least, the instruction decoder and the ALU work as expected!
- The FSM starts at `state=1` which means the instruction decoder is enabled as soon as the simulation starts...
  - As a consequence, instructions will be skipped until the next occurence of `start=1` (happenning 4 cycles later).
  - If the FSM start at `state=0` (nothing enabled), it will let Homer a single cycle before enabling the instruction decoder. 
>>>>>>> master

- In other words, Homer seems to handle instructions as expected. Just need to manage the incoming instructions stream.