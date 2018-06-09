enum MyMessageType
{
    UNICAST = 0;
    MULTICAST = 1;
    THIRD_TYPE = 2;
    MORE_COLORS = 3;
    EVEN_MORE = 4;
};


message MyMessage
{
    int source;
	int destination;
	int hopCount = 0;
	bool isACK = false;
	simtime_t startTime;
}
