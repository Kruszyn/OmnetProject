
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



network Network
{
    @display("bgb=911,510;bgl=10");
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
        switch0: Switch;
        switch1: Switch;
        server0: Server;
        server1: Server;
        server2: Server;
        printer0: Printer;
        laptop0: Laptop;
        pc0: PC;
        phone0: Phone;
    connections:
        backbone0.opticGate++ <--> Fiber <--> backbone1.opticGate++;
        backbone1.opticGate++ <--> Fiber <--> backbone2.opticGate++;
        backbone2.opticGate++ <--> Fiber <--> backbone3.opticGate++;
        backbone3.opticGate++ <--> Fiber <--> backbone4.opticGate++;
        backbone4.opticGate++ <--> Fiber <--> backbone0.opticGate++;

        backbone0.opticGate++ <--> Fiber <--> edge0.opticGate++;
        backbone2.opticGate++ <--> Fiber <--> edge1.opticGate++;
        backbone4.opticGate++ <--> Fiber <--> edge2.opticGate++;

        edge2.gate++ <--> Eth100 <--> switch0.gate++;
        edge2.gate++ <--> Eth100 <--> switch1.gate++;

        switch0.gate++ <--> Eth100 <--> server0.gate++;
        switch0.gate++ <--> Eth100 <--> server1.gate++;
        switch0.gate++ <--> Eth100 <--> server2.gate++;

        switch1.gate++ <--> Eth100 <--> pc0.gate++;
        switch1.gate++ <--> Eth100 <--> phone0.gate++;
        switch1.gate++ <--> Eth100 <--> laptop0.gate++;
        switch1.gate++ <--> Eth100 <--> printer0.gate++;



}
