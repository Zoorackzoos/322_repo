# fuckass_diagram_table.md

## peepee poopoo official blursion 

| _                              | Reg2Sel | Src@Sel | ALUop                         | WriteMem | ReadMem | WriteSel | WriteReg | Branch | Jump | 
|--------------------------------|---------|---------|-------------------------------|----------|---------|----------|----------|--------|------| 
| Register-register arithmetic   | 0       | 0       | add, subtract, multiply, etc  | 0        | 0       | 1        | 1        | 0      | 0    |
| Register-immediate arithmetric | x       | 1       | add, subtract, multiply, etc. | 0        | 0       | 1        | 1        | 0      | 0    |
| ldr                            | x       | 1       | Add                           | 0        | 1       | 0        | 1        | 0      | 0    |
| str                            | 1       | 1       | Add                           | 1        | 0       | x        | 0        | 0      | 0    |
| cmp                            | 0       | 0       | Subtract                      | 0        | 0       | x        | 0        | 0      | 0    | 
| beq                            | x       | x       | x                             | 0        | 0       | x        | 0        | 1      | 0    |
| br / blr / ret                 | x       | x       | x                             | 0        | 0       | x        | 0        | 0      | 1    |
