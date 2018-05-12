
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

simple MyMessage
{
    parameters:
        @display("o=black,black,12");
}


network Network
{
    @display("bgb=695,450;bgl=3");
    types:
        channel Fiber extends ned.DatarateChannel
        {
            @display("ls=red");
            datarate = 10Gbps;
            delay = 1ms;
            ber = 1e-10;

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
            @display("p=354,248");
        }
        backbone1: Router {
            @display("p=257,248");
        }
        backbone2: Router {
            @display("p=165,248");
        }
        backbone3: Router {
            @display("p=204,158");
        }
        backbone4: Router {
            @display("p=315,158");
        }
        edge0: Router {
            @display("p=449,248");
        }
        edge1: Router {
            @display("p=61,248");
        }
        edge2: Router {

            @display("p=393,73");
        }
    connections:
        backbone0.gate++ <--> Fiber <--> backbone1.gate++;
        backbone1.gate++ <--> Fiber <--> backbone2.gate++;
        backbone2.gate++ <--> Fiber <--> backbone3.gate++;
        backbone3.gate++ <--> Fiber <--> backbone4.gate++;
        backbone4.gate++ <--> Fiber <--> backbone0.gate++;

        backbone0.gate++ <--> Fiber <--> edge0.gate++;
        backbone2.gate++ <--> Fiber <--> edge1.gate++;
        backbone4.gate++ <--> Fiber <--> edge2.gate++;




}
