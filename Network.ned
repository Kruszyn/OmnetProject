
simple Object
{
    gates:
        inout gate[];
}
simple Router extends Object
{
    parameters:
        @display("i=abstract/router");
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
        channel Fiber extends ned.DatarateChannel
        {
            @display("ls=red");
            datarate = 10Gbps;
            delay = 1ms;
            ber = 0.01;

        }
        channel Eth100 extends ned.DatarateChannel
        {
            @display("ls=blue");
            datarate = 100Mbps;
            delay = 10ms;
            per = 1e-10;
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
        backbone0.gate++ <--> Fiber <--> backbone1.gate++;
        backbone1.gate++ <--> Fiber <--> backbone2.gate++;
        backbone2.gate++ <--> Fiber <--> backbone3.gate++;
        backbone3.gate++ <--> Fiber <--> backbone4.gate++;
        backbone4.gate++ <--> Fiber <--> backbone0.gate++;

        backbone0.gate++ <--> Fiber <--> edge0.gate++;
        backbone2.gate++ <--> Fiber <--> edge1.gate++;
        backbone4.gate++ <--> Fiber <--> edge2.gate++;

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
