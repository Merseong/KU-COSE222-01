# 컴퓨터구조 Milestone 3

## 현재 구현된것

*   Rtype
    *   and
    *   or
    *   slt
    *   add, addu
    *   sub, subu
*   lw
*   sw
*   beq
*   addi, addiu
*   ori
*   lui
*   j

## 구현해야 할 것

- [x]   nop 
    * 00000000  (nop)
    * 0000 00/00 000/0 0000/ 0000 0/000 00/00 0000
    * [x] aludec에서 funct가 00000일때 0과 0을 or하게 만듬
- [x]   li
    * addui랑 같음
- [x]   jal
    * 0c00002a 	(jal	a8 \<display\>)
    * 0000 11/00 0000 0000 0000 0000 0010 1010
    * [x] alusrc와 regdst의 길이를 2로 늘림 (to [1:0]): controller, datapath의 input과 output 수정
    * [x] controller에서, jal의 코드를 받으면 적당한 컨트롤을 뱉게함 -> jump와 or $31, pcplus4, $0을 하도록
    * [x] mux4를 만들어 regdst와 alusrc 맞게 만들기
    * [x] regdst가 10일때 $31을 뱉게 만듬
    * [x] alusrc가 10일때 pcplus4를 뱉게함
    * [x] 문제점: [1:0]으로 인풋을 넣어줘도 ModelSim에서는 1bit으로 인식함
- [x]   jr
    * 03e00008 	(jr	ra)
    * 0000 00/11 111/0 0000/ 0000 0/000 00/00 1000
    * [x] pcmux의 s를 [1:0]으로 늘리고 mux4로 바꾸기
    * [x] aluout과 연결해서 pc에 $31의 값이 들어가게 
- [x]   sltu
    * 0062102b 	(sltu	v0,v1,v0)
    * 0000 00/00 011/0 0010/ 0001 0/000 00/10 1011
    * [x] alu에 이미 sltu가 있으니 그냥 가져다쓰면될듯
    * [x] alucont [1:0]으로 늘리기, 관련된거 다 늘려야됨
    * [x] 나머진 그냥 R타입이랑 같으니 냅두면될듯
    * [x] ~C를 했을때 LSB만 바뀌는 문제점
- [ ]   bnez
    * 1440fff7 	(bnez	v0,38 \<SevenSeg+0x28\>)
- [x]   move
    * add랑 같음