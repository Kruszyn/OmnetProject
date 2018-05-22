message MyMessage
{
    int source;
	int destination;
	int hopCount = 0;
	int type; //0 = UNICAST , 1 = MULTICAST
	bool isACK = false;
	simtime_t startTime;
}
