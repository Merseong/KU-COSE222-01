# Milestone 6

## new instruction

- [x] slti (a8: 28420005 == slti v0, v0, 5)
    - 0010 10/00 010/0 0010/ 0000 0000 0000 0101
    - if $s < imm $t = 1; else $t = 0;
    - [x] aluop 1개씩 늘려서 [2:0]으로
    - [x] ex_control들 1씩 늘려서 [11:0]으로
        - [x] ex_control 사용하는것들 한개씩 밀어줘야됨
- [x] forwarding시 rt나 rs가 0이면 포워딩하면 안된다.