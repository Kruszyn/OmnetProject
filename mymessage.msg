message MyMessage
{
    int source;
	int destination;
	int hopCount = 0;
	int type = 0; //0 = UNICAST
	bool isACK = false;
	simtime_t startTime;
}
