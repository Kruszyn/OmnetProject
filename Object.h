/*
 * Object.h
 *
 *  Created on: May 10, 2018
 *      Author: Kamil Korenkiewicz
 */

#ifndef OBJECT_H_
#define OBJECT_H_


class Object : public cSimpleModule{

  static int count; //NETWORK OBJECTs COUNT

  static const int unicastTarget = 10;
  static const int unicastSource = 3;
  static const int unicastMessageCountTarget = 1000;
  static int unicastMessageCount;
  MyMessage *nextMsg;

  static const int multicastSource = 13;
  static int multicastGroup[3];
  static const int multicastMessageCountTarget = 1000;
  static int multicastMessageCount;

  //state variables
  enum { IDLE = 0, TRANSMIT = 1, FAILURE = 2 } state;
  simtime_t  stateTime;

  //stats
  long numSent;
  long numReceived;
  long numLost;
  cLongHistogram hopCountStats;
  cOutVector hopCountVector;
  cDoubleHistogram timeStats;
  cOutVector timeVector;

  protected:
    void collectStats(int hopC, simtime_t time);
    void decideOnMsgType(MyMessage *msg);
    void handleUnicast(MyMessage *msg);
    void handleMulticast();
    void sendMulticast();
    void sendMultirate();
    MyMessage *generateUnicastMessage(bool isResponse);
    virtual MyMessage *generateMessage();
    virtual void forwardMessage(MyMessage *msg);
    virtual void initialize() override;
    virtual void handleMessage(cMessage *msg) override;
    virtual void refreshDisplay() const override;
    void finish();


};


#endif /* OBJECT_H_ */
