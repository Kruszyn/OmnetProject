/*
 * Object.h
 *
 *  Created on: May 10, 2018
 *      Author: student
 */

#ifndef OBJECT_H_
#define OBJECT_H_


class Object : public cSimpleModule{

  static int count;
  //stats
  long numSent;
  long numReceived;
  long numLost;

  protected:
    virtual MyMessage *generateMessage();
    virtual void forwardMessage(MyMessage *msg);
    virtual void initialize() override;
    virtual void handleMessage(cMessage *msg) override;
    virtual void refreshDisplay() const override;
};


#endif /* OBJECT_H_ */
