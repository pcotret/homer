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
| 0000   | ADD                     |                           |
| 0001   | SUB                     |                           |
| 0010   | OR                      | :ballot_box_with_check:   |
| 0011   | XOR                     |                           |
| 0100   | AND                     |                           |
| 0101   | NOT                     |                           |
| 0110   | Read                    |                           |
| 0111   | Write                   |                           |
| 1000   | Load                    |                           |
| 1001   | Compare                 |                           |
| 1010   | Shift L                 |                           |
| 1011   | Shift R                 |                           |
| 1100   | Jump                    |                           |
| 1101   | Jump conditonal         |                           |
| 1110   | Reserved for future use |                           |
| 1111   | Reserved for future use |                           |