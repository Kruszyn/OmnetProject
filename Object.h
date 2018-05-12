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
  int address;

  protected:
    virtual MyMessage *generateMessage();
    virtual void forwardMessage(MyMessage *msg);
    virtual void initialize() override;
    virtual void handleMessage(cMessage *msg) override;
};


#endif /* OBJECT_H_ */
