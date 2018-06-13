
simple Object
{
    gates:
        inout gate[];
}
simple Router extends Object
{
    parameters:
        @display("i=abstract/router");
    gates:
        inout opticGate[];
}
simple Switch extends Object
{
    parameters:
        @display("i=abstract/switch");
}
simple Phone extends Object
{
    parameters:
        @display("i=old/dialphone");
}
simple Server extends Object
{
    parameters:
        @display("i=device/server");
}
simple PC extends Object
{
    parameters:
        @display("i=device/pc");
}
simple Laptop extends Object
{
    parameters:
        @display("i=device/laptop");
}
simple Printer extends Object
{
    parameters:
        @display("i=device/printer");
}
simple Internet extends Object
{
    parameters:
        @display("i=misc/cloud");
}



network Network
{
    @display("bgb=1286.7188,530.7;bgl=16");
    types:
        channel Fiber extends ned.DelayChannel
        {
            @display("ls=red");
            delay = 1ms;
        }
        channel Eth100 extends ned.DelayChannel
        {
            @display("ls=blue");
            delay = 10ms;
        }

    submodules:
        backbone0: Router {
            @display("p=534,318");
        }
        backbone1: Router {
            @display("p=437,318");
        }
        backbone2: Router {
            @display("p=345,318");
        }
        backbone3: Router {
            @display("p=384,228");
        }
        backbone4: Router {
            @display("p=495,228");
        }
        edge0: Router {
            @display("p=629,318");
        }
        edge1: Router {
            @display("p=241,318");
        }
        edge2: Router {

            @display("p=495,146");
        }
        internet: Internet;
        switch0: Switch;
        switch1: Switch;
        switch2: Switch;
        switch3: Switch;
        switch4: Switch;
        switch5: Switch;
        switch6: Switch;
        switch7: Switch;
        switch8: Switch;
        switch9: Switch;
        switch10: Switch;
        switch11: Switch;
        switch12: Switch;
        switch13: Switch;
        switch14: Switch;
        switch15: Switch;
        server0: Server;
        server1: Server;
        server2: Server;
        server3: Server;
        server4: Server;
        server5: Server;
        server6: Server;
        server7: Server;
        printer0: Printer;
        printer1: Printer;
        printer2: Printer;
        printer3: Printer;
        printer4: Printer;
        laptop0: Laptop;
        laptop1: Laptop;
        laptop2: Laptop;
        laptop3: Laptop;
        laptop4: Laptop;
        laptop5: Laptop;
        laptop6: Laptop;
        laptop7: Laptop;
        laptop8: Laptop;
        laptop9: Laptop;
        laptop10: Laptop;
        laptop11: Laptop;
        laptop12: Laptop;
        laptop13: Laptop;
        laptop14: Laptop;
        laptop15: Laptop;
        laptop16: Laptop;
        laptop17: Laptop;
        laptop18: Laptop;
        laptop19: Laptop;
        laptop20: Laptop;
        laptop21: Laptop;
        laptop22: Laptop;
        laptop23: Laptop;
        laptop24: Laptop;
        laptop25: Laptop;
        pc0: PC;
        pc1: PC;
        pc2: PC;
        pc3: PC;
        phone0: Phone;
        phone1: Phone;
        phone2: Phone;
        phone3: Phone;
        phone4: Phone;
        phone5: Phone;
        phone6: Phone;
        phone7: Phone;
        phone8: Phone;
        phone9: Phone;
        phone10: Phone;
        phone11: Phone;
        phone12: Phone;
        phone13: Phone;
        phone14: Phone;
        phone15: Phone;
        phone16: Phone;
        phone17: Phone;
        phone18: Phone;
        phone19: Phone;
        phone20: Phone;
        phone21: Phone;
        phone22: Phone;
        phone23: Phone;
    connections:

        backbone0.opticGate++ <--> Fiber <--> backbone1.opticGate++;
        backbone1.opticGate++ <--> Fiber <--> backbone2.opticGate++;
        backbone2.opticGate++ <--> Fiber <--> backbone3.opticGate++;
        backbone3.opticGate++ <--> Fiber <--> backbone4.opticGate++;
        backbone4.opticGate++ <--> Fiber <--> backbone0.opticGate++;

        backbone3.opticGate++ <--> Fiber <--> internet.gate++;

        backbone0.opticGate++ <--> Fiber <--> edge0.opticGate++;
        backbone2.opticGate++ <--> Fiber <--> edge1.opticGate++;
        backbone4.opticGate++ <--> Fiber <--> edge2.opticGate++;
        //DOSTĘP
        edge0.gate++ <--> Eth100 <--> switch0.gate++;
        edge0.gate++ <--> Eth100 <--> switch1.gate++;
        edge0.gate++ <--> Eth100 <--> switch2.gate++;
        edge0.gate++ <--> Eth100 <--> switch3.gate++;
        edge0.gate++ <--> Eth100 <--> switch4.gate++;
        edge0.gate++ <--> Eth100 <--> switch5.gate++;


        edge1.gate++ <--> Eth100 <--> switch6.gate++;
        edge1.gate++ <--> Eth100 <--> switch7.gate++;
        edge1.gate++ <--> Eth100 <--> switch8.gate++;
        edge1.gate++ <--> Eth100 <--> switch9.gate++;
        edge1.gate++ <--> Eth100 <--> switch10.gate++;

        edge2.gate++ <--> Eth100 <--> switch11.gate++;
        edge2.gate++ <--> Eth100 <--> switch12.gate++;
        edge2.gate++ <--> Eth100 <--> switch13.gate++;
        edge2.gate++ <--> Eth100 <--> switch14.gate++;
        edge2.gate++ <--> Eth100 <--> switch15.gate++;

		//SWITCH 
        switch0.gate++ <--> Eth100 <--> server0.gate++;
        switch0.gate++ <--> Eth100 <--> server1.gate++;
        switch0.gate++ <--> Eth100 <--> server2.gate++;
        switch0.gate++ <--> Eth100 <--> phone0.gate++;
        switch0.gate++ <--> Eth100 <--> phone1.gate++;
        switch0.gate++ <--> Eth100 <--> phone2.gate++;
        switch0.gate++ <--> Eth100 <--> phone3.gate++;
        switch0.gate++ <--> Eth100 <--> phone4.gate++;

        switch1.gate++ <--> Eth100 <--> pc0.gate++;
        switch1.gate++ <--> Eth100 <--> phone5.gate++;
        switch1.gate++ <--> Eth100 <--> phone6.gate++;
        switch1.gate++ <--> Eth100 <--> phone7.gate++;
        switch1.gate++ <--> Eth100 <--> laptop0.gate++;
        switch1.gate++ <--> Eth100 <--> laptop1.gate++;
        switch1.gate++ <--> Eth100 <--> laptop2.gate++;
        switch1.gate++ <--> Eth100 <--> printer0.gate++;

        switch2.gate++ <--> Eth100 <--> phone8.gate++;
        switch2.gate++ <--> Eth100 <--> phone9.gate++;
        switch2.gate++ <--> Eth100 <--> phone10.gate++;
        switch2.gate++ <--> Eth100 <--> phone11.gate++;
        switch2.gate++ <--> Eth100 <--> phone12.gate++;
        switch2.gate++ <--> Eth100 <--> phone13.gate++;

        switch3.gate++ <--> Eth100 <--> phone14.gate++;
        switch3.gate++ <--> Eth100 <--> phone15.gate++;
        switch3.gate++ <--> Eth100 <--> laptop3.gate++;
        switch3.gate++ <--> Eth100 <--> laptop4.gate++;

        switch4.gate++ <--> Eth100 <--> phone16.gate++;
        switch4.gate++ <--> Eth100 <--> phone17.gate++;

        switch5.gate++ <--> Eth100 <--> phone18.gate++;
        switch5.gate++ <--> Eth100 <--> phone11.gate++;
        switch5.gate++ <--> Eth100 <--> pc3.gate++;
        switch5.gate++ <--> Eth100 <--> laptop5.gate++;
        switch5.gate++ <--> Eth100 <--> laptop6.gate++;
        switch5.gate++ <--> Eth100 <--> printer1.gate++;


        switch6.gate++ <--> Eth100 <--> phone19.gate++;
        switch6.gate++ <--> Eth100 <--> phone20.gate++;

        switch7.gate++ <--> Eth100 <--> phone21.gate++;
        switch7.gate++ <--> Eth100 <--> laptop7.gate++;
        switch7.gate++ <--> Eth100 <--> laptop8.gate++;
        switch7.gate++ <--> Eth100 <--> laptop9.gate++;
        switch7.gate++ <--> Eth100 <--> laptop10.gate++;
        switch7.gate++ <--> Eth100 <--> laptop11.gate++;
        switch7.gate++ <--> Eth100 <--> laptop12.gate++;
        switch7.gate++ <--> Eth100 <--> printer2.gate++;
        switch7.gate++ <--> Eth100 <--> printer3.gate++;


        switch8.gate++ <--> Eth100 <--> phone22.gate++;
        switch8.gate++ <--> Eth100 <--> laptop13.gate++;
        switch8.gate++ <--> Eth100 <--> laptop14.gate++;

        switch9.gate++ <--> Eth100 <--> phone23.gate++;

        switch10.gate++ <--> Eth100 <--> pc1.gate++;
        switch10.gate++ <--> Eth100 <--> pc2.gate++;
        switch10.gate++ <--> Eth100 <--> laptop15.gate++;
        switch10.gate++ <--> Eth100 <--> laptop16.gate++;
        switch10.gate++ <--> Eth100 <--> laptop17.gate++;
        switch10.gate++ <--> Eth100 <--> printer4.gate++;
        switch10.gate++ <--> Eth100 <--> server7.gate++;

        switch11.gate++ <--> Eth100 <--> laptop18.gate++;
        switch11.gate++ <--> Eth100 <--> laptop19.gate++;
        switch11.gate++ <--> Eth100 <--> laptop20.gate++;
        switch11.gate++ <--> Eth100 <--> laptop21.gate++;
        switch11.gate++ <--> Eth100 <--> laptop22.gate++;

        switch12.gate++ <--> Eth100 <--> server3.gate++;
        switch12.gate++ <--> Eth100 <--> server4.gate++;
        switch12.gate++ <--> Eth100 <--> server5.gate++;
        switch12.gate++ <--> Eth100 <--> server6.gate++;

        switch13.gate++ <--> Eth100 <--> laptop23.gate++;
        switch13.gate++ <--> Eth100 <--> laptop24.gate++;
        switch13.gate++ <--> Eth100 <--> laptop25.gate++;


}

