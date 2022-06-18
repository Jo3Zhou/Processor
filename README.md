# Processor
A single-cycle processor based on VHDL with components followed below:
1. Processing Unit (ALU, (parameterizable) register bank, data path)
2. Control Unit (insturction register, sequencer, decode logic)
3. MMU memory management unit
4. Dual-port ROM
5. Ouput register

P.S. A processor with lots of bugs xD

The instruction set：
![image](https://user-images.githubusercontent.com/102744628/173556058-1b35660d-5966-4856-8872-0a65f017eb5a.png)

43 Assembly language instructions and compiled into binary in dual-port ROM:
![image](https://user-images.githubusercontent.com/102744628/174089568-817300bf-1a9a-42dd-b904-b7142178e967.png)
![image](https://user-images.githubusercontent.com/102744628/174089598-2cf10cb5-3236-4bd8-974b-982cabfee5f2.png)


part of simulation:
![image](https://user-images.githubusercontent.com/102744628/173555533-5d009fdd-2ca0-471e-910b-ee8d915f8ac1.png)
