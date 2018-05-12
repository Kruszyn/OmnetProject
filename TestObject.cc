#include <stdio.h>
#include <string.h>
#include <omnetpp.h>

using namespace omnetpp;


#include "mymessage_m.h"

class TestObject : public cSimpleModule
{

    protected:
      virtual MyMessage *generateMessage();
      virtual void forwardMessage(MyMessage *msg);
      virtual void initialize() override;
      virtual void handleMessage(cMessage *msg) override;

};
Define_Module(TestObject);

void TestObject::initialize() {
    MyMessage *msg = generateMessage();
    EV << "Generating UNICAST message " << msg;
    scheduleAt(0.0, msg);
}

MyMessage *TestObject::generateMessage() {
    // Produce source and destination addresses.
    int src = 0;  // our module index
    int n = getVectorSize();  // module vector size
    int dest = intuniform(0, n - 2);
    if (dest >= src)
        dest++;

    char msgname[29];
    sprintf(msgname, "tic-%d-to-%d", src, dest);

    // Create message object and set source and destination field.
    MyMessage *msg = new MyMessage(msgname);
    msg->setSource(src);
    msg->setDestination(dest);
    return msg;
}

void TestObject::forwardMessage(MyMessage *msg)
{
    // Increment hop count.
    msg->setHopCount(msg->getHopCount()+1);

    // Same routing as before: random gate.
    int n = gateSize("gate");
    int k = intuniform(0, n-1);

    EV << "Forwarding message " << msg << " on gate[" << k << "]\n";
    send(msg, "gate$o", k);
}

void TestObject::handleMessage(cMessage *msg)
{
    MyMessage *ttmsg = check_and_cast<MyMessage *>(msg);

    if (ttmsg->getDestination() == getIndex()) {
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
