#include <stdio.h>
#include <string.h>
#include <omnetpp.h>

using namespace omnetpp;


#include "mymessage_m.h"
#include "Object.h"

//Network counts as first object with id=1;
int Object::count = 1;
int Object::unicastMessageCount = 0;
Define_Module(Object);

void Object::initialize()
{
    count++;
    numSent = 0;
    numReceived = 0;
    numLost = 0;

    WATCH(numSent);
    WATCH(numReceived);

    hopCountStats.setName("hopCountStats");
    hopCountStats.setRangeAutoUpper(0, 10, 1.5);
    hopCountVector.setName("HopCount");

   // Module 0 sends the first message
    if (getId() == unicastSource) {
        MyMessage *msg = generateUnicastMessage(false);
        numSent++;
        scheduleAt(0.0, msg);
    }
}

void Object::handleMessage(cMessage *msg)
{
    MyMessage *ttmsg = check_and_cast<MyMessage *>(msg);

    if (uniform(0, 1) < 0.001) {
        EV << "\"Losing\" message\n";
        numLost++;
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
    switch( msg->getType() )
    {
        case 0:
            handleUnicast(msg);
            break;
        case 1:
            //jakiś kod
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

MyMessage *Object::generateUnicastMessage(bool isResponse){

    MyMessage *msg = generateMessage();
    if(isResponse){
        msg->setDestination(unicastSource);
    }
    else{
        msg->setDestination(unicastTarget);
    }
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
    // Increment hop count.
    msg->setHopCount(msg->getHopCount()+1);
    // Same routing as before: random gate.
    int n = gateSize("gate");
    //EV << "GATE SIZE:     " << n << endl;
    int k = intuniform(0, n-1);
    //EV << "GATE PICKED:     " << k << endl;
    //EV << "Forwarding message " << msg << " on gate[" << k << "]\n";
    send(msg, "gate$o", k);
}

void Object::refreshDisplay() const
{
    char buf[40];
    sprintf(buf, "R: %1d S: %1d L: %1d", numReceived, numSent, numLost);
    getDisplayString().setTagArg("t", 0, buf);
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
