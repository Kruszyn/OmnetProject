#include <stdio.h>
#include <string.h>
#include <omnetpp.h>

using namespace omnetpp;


#include "mymessage_m.h"
#include "Object.h"

int Object::count = 1;

Define_Module(Object);

void Object::initialize()
{
       count++;
   // Module 0 sends the first message
    if (getId() == 2) {
        MyMessage *msg = generateMessage();
        scheduleAt(0.0, msg);
    }
}

void Object::handleMessage(cMessage *msg)
{
    MyMessage *ttmsg = check_and_cast<MyMessage *>(msg);

    if (ttmsg->getDestination() == getId()) {
        // Message arrived.
        EV << "Message " << ttmsg << " arrived after " << ttmsg->getHopCount() << " hops.\n";
        bubble("ARRIVED, starting new one!");
        delete ttmsg;

        // Generate another one.
        EV << "Generating another message: ";
        MyMessage *newmsg = generateMessage();
        EV << newmsg << endl;
        forwardMessage(newmsg);
    }
    else {
        // We need to forward the message.
        forwardMessage(ttmsg);
    }
}

MyMessage *Object::generateMessage()
{
    // Produce source and destination addresses.
    int src = getId();  // our module index
    int dest = intuniform(2, count);
    if(src == dest){dest++;}

    char msgname[20];
    sprintf(msgname, "tic-%d-to-%d", src, dest);

    // Create message object and set source and destination field.
    MyMessage *msg = new MyMessage(msgname);

    msg->setSource(src);
    msg->setDestination(dest);
    return msg;
}

void Object::forwardMessage(MyMessage *msg)
{
    // Increment hop count.
    msg->setHopCount(msg->getHopCount()+1);

    // Same routing as before: random gate.
    int n = gateSize("gate");
    int k = intuniform(0, n-1);

    EV << "Forwarding message " << msg << " on gate[" << k << "]\n";
    send(msg, "gate$o", k);
}


