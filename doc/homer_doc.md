# Homer documentation

## Instruction formats

| Instruction        | 15-12    | 11-8      | 7-4        | 3-0        |
| ------------------ | -------- | --------- | ---------- | ---------- |
| RRR (i.e. `ADD`)   | `opcode` | `reg_dst` | `reg_src1` | `reg_src2` |
| Rrd (i.e. `NOT`)   | `opcode` | `reg_dst` | `reg_src1` | unused     |
| RImm (i.e. `LOAD`) | `opcode` | `reg_dst` | `Imm(7-4)` | `Imm(3-0)` |

## Opcodes

| Opcode | Instruction             | Implemented and validated |
| ------ | ----------------------- | ------------------------- |
| 0000   | ADD                     | Done                      |
| 0001   | SUB                     |                           |
| 0010   | OR                      | Done                      |
| 0011   | XOR                     | Done                      |
| 0100   | AND                     | Done                      |
| 0101   | NOT                     | Done                      |
| 0110   | Read                    |                           |
| 0111   | Write                   |                           |
| 1000   | Load                    | Done                      |
| 1001   | Compare                 | Done                      |
| 1010   | Shift L                 | Done                      |
| 1011   | Shift R                 | Done                      |
| 1100   | Jump                    |                           |
| 1101   | Jump conditonal         |                           |
| 1110   | Reserved for future use |                           |
| 1111   | Reserved for future use |                           |