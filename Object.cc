#include <stdio.h>
#include <string.h>
#include <omnetpp.h>

using namespace omnetpp;


#include "mymessage_m.h"
#include "Object.h"

//Network counts as first object with id=1;
int Object::count = 1;
int Object::unicastMessageCount = 0;
int Object::multicastMessageCount = 0;
int Object::multicastGroup[] = {7,16,17};
Define_Module(Object);

void Object::initialize()
{
    count++;
    numSent = 0;
    numReceived = 0;
    numLost = 0;

    state = IDLE;

    WATCH(numSent);
    WATCH(numReceived);

    hopCountStats.setName("hopCountStats");
    hopCountStats.setRangeAutoUpper(0, 10, 1.5);
    hopCountVector.setName("HopCount");


    if (getId() == unicastSource) {
        MyMessage *msg = generateUnicastMessage(false);
        numSent++;
        scheduleAt(0.0, msg);
    }
/*    if(getId() == multicastSource){
        sendMulticast();
    }*/

/*    if(getId() == multicastSource){
        sendMultirate();
    }*/
}

void Object::handleMessage(cMessage *msg)
{
    MyMessage *ttmsg = check_and_cast<MyMessage *>(msg);

    if (uniform(0, 1) < 0) {
        EV << "\"Losing\" message\n";
        numLost++;
        state = FAILURE;
        stateTime = cSimulation::getActiveSimulation()->getSimTime();
        delete msg;
    } else {

        if (ttmsg->getDestination() == getId()) {
            // Message arrived.
            int hopcount = ttmsg->getHopCount();
            simtime_t  msgTime = cSimulation::getActiveSimulation()->getSimTime()-(ttmsg->getStartTime());
            collectStats(hopcount, msgTime);

            decideOnMsgType(ttmsg);
            delete ttmsg;
        }
        else {
            forwardMessage(ttmsg);
        }
    }
}

void Object::collectStats(int hopC, simtime_t time){
    numReceived++;
    hopCountVector.record(hopC);
    hopCountStats.collect(hopC);

    timeVector.record(time);
    timeStats.collect(time);
}

void Object::decideOnMsgType(MyMessage *msg){
    switch( msg->getKind() )
    {
        case 0:
            handleUnicast(msg);
            break;
        case 1:
            handleMulticast();
            break;
        case 2:
            //jakiś kod
            break;
        default:
            //jakiś kod
            break;
    }
}

void Object::handleUnicast(MyMessage *msg){
    MyMessage *newmsg;
    if(msg->getIsACK() == false){
        //Unicast msg incoming in node, we need to
        //send ACK
        newmsg = generateUnicastMessage(true);
        numSent++;

    } else {
        //ACK walks into bar, we need to throw another Unicast out
        if(unicastMessageCount<unicastMessageCountTarget){
           EV << "Generating UNICAST message n" << unicastMessageCount;
           newmsg = generateUnicastMessage(false);
           numSent++;
           EV << newmsg << endl;
        }else{
           EV << "THATS ALL!";
        }
    }

    if(newmsg != nullptr){
        forwardMessage(newmsg);
    }
}

void Object::handleMulticast(){
    bubble("Multicast arrived!");
}

void Object::sendMulticast(){
    double timeCounter = 0;

    for(int x=0; x<multicastMessageCountTarget; x++){

        for(int i=0; i<3; i++){
            MyMessage *msg = generateMessage();
            msg->setKind(1);

            int z = multicastGroup[i];
            msg->setDestination(z);
            scheduleAt(timeCounter, msg);
            timeCounter+=0.01;
        }
        timeCounter++;
        multicastMessageCount++;
    }
}

void Object::sendMultirate(){

    for(int i=1; i<5; i++){
        MyMessage *msg = generateMessage();
        msg->setKind(i);
        msg->setDestination(multicastGroup[0]);

        scheduleAt(0.0, msg);
    }
}

MyMessage *Object::generateUnicastMessage(bool isResponse){

    MyMessage *msg = generateMessage();
    if(isResponse){
        msg->setDestination(unicastSource);
    }
    else{
        msg->setDestination(unicastTarget);
    }
    msg->setKind(0);
    msg->setIsACK(isResponse);
    unicastMessageCount++;
    char msgname[20];
    sprintf(msgname, "Unicast f-%d-to-%d", getId(), msg->getDestination());
    msg->setName(msgname);
    return msg;
}

MyMessage *Object::generateMessage()
{
    // Produce source and destination addresses.
    int src = getId();  // our module index
    int dest = intuniform(2, count);

    char msgname[20];
    sprintf(msgname, "tic-%d-to-%d", src, dest);
    simtime_t  simTime = cSimulation::getActiveSimulation()->getSimTime();
    // Create message object and set source and destination field.
    MyMessage *msg = new MyMessage(msgname);
    msg->setSource(src);
    msg->setDestination(dest);
    msg->setStartTime(simTime);
    return msg;
}

void Object::forwardMessage(MyMessage *msg)
{
    state = TRANSMIT;
    stateTime = cSimulation::getActiveSimulation()->getSimTime();

    // Increment hop count.
    msg->setHopCount(msg->getHopCount()+1);
    // Same routing as before: random gate.
    int m = 0;
    int n = gateSize("gate");
    if(hasGate("opticGate")) m = gateSize("opticGate");
    int temp;
    if(n==0){
        temp = m;
        int k = intuniform(0, temp-1);
        send(msg, "opticGate$o", k);
    }
    else if(m==0){
        temp = n;
        int k = intuniform(0, temp-1);
        send(msg, "gate$o", k);
    }
    else{
        if(intuniform(0,1)==1){
            temp = m;
            int k = intuniform(0, temp-1);
            send(msg, "opticGate$o", k);
        }
        else{
            temp = n;
            int k = intuniform(0, temp-1);
            send(msg, "gate$o", k);
        }
    }

    //EV << "GATE PICKED:     " << k << endl;
    //EV << "Forwarding message " << msg << " on gate[" << k << "]\n";
}

void Object::refreshDisplay() const
{
    char buf[40];
    sprintf(buf, "R: %1d S: %1d L: %1d", numReceived, numSent, numLost);
    getDisplayString().setTagArg("t", 0, buf);
    if(state == IDLE) getDisplayString().setTagArg("i", 1, "grey");
    else if(state == TRANSMIT) getDisplayString().setTagArg("i", 1, "green");
    else if(state == FAILURE) getDisplayString().setTagArg("i", 1, "red");

}

void Object::finish()
{
    // This function is called by OMNeT++ at the end of the simulation.
    EV << "Sent:     " << numSent << endl;
    EV << "Received: " << numReceived << endl;
    EV << "Lost:     " << numLost << endl;
    EV << "Hop count, min:    " << hopCountStats.getMin() << endl;
    EV << "Hop count, max:    " << hopCountStats.getMax() << endl;
    EV << "Hop count, mean:   " << hopCountStats.getMean() << endl;
    EV << "Min time           " << timeStats.getMin() * 1000<< "ms" <<endl;
    EV << "Avg time           " << timeStats.getMean()* 1000 << "ms" <<endl;
    EV << "Max time           " << timeStats.getMax() * 1000 << "ms" << endl;
    recordScalar("#sent", numSent);
    recordScalar("#received", numReceived);

    hopCountStats.recordAs("hop count");
}
