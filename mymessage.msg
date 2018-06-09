enum MyMessageType
{
    UNICAST = 0;
    MULTICAST = 1;
};


message MyMessage
{
    int source;
	int destination;
	int hopCount = 0;
	bool isACK = false;
	simtime_t startTime;
}
