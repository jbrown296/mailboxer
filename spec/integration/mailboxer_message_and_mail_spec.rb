require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Mailboxer Messages And Mails" do 
  
  describe "two equal entities" do
    before do
      @entity1 = Factory(:user)
      @entity2 = Factory(:user)
    end
    
    describe "message sending" do    
      
      before do
        @mail1 = @entity1.send_message(@entity2,"Body","Subject")
        @message1 = @mail1.mailboxer_message
      end
      
      it "should create proper message" do
        @message1.sender.id.should == @entity1.id
        @message1.sender.class.should == @entity1.class
        assert @message1.body.eql?"Body"
        assert @message1.subject.eql?"Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message1.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
      end
      
    end
    
    describe "message replying to sender" do
      before do
        @mail1 = @entity1.send_message(@entity2,"Body","Subject")
        @mail2 = @entity2.reply_to_sender(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
    
    describe "message replying to all" do
      before do
        @mail1 = @entity1.send_message(@entity2,"Body","Subject")
        @mail2 = @entity2.reply_to_all(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
  end
  
  describe "two different entities" do
    before do
      @entity1 = Factory(:user)
      @entity2 = Factory(:duck)
    end
    
    describe "message sending" do    
      
      before do
        @mail1 = @entity1.send_message(@entity2,"Body","Subject")
        @message1 = @mail1.mailboxer_message
      end
      
      it "should create proper message" do
        @message1.sender.id.should == @entity1.id
        @message1.sender.class.should == @entity1.class
        assert @message1.body.eql?"Body"
        assert @message1.subject.eql?"Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message1.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
      end
      
    end
    
    describe "message replying to sender" do
      before do
        @mail1 = @entity1.send_message(@entity2,"Body","Subject")
        @mail2 = @entity2.reply_to_sender(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
    
    describe "message replying to all" do
      before do
        @mail1 = @entity1.send_message(@entity2,"Body","Subject")
        @mail2 = @entity2.reply_to_all(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
  end
  
  describe "three equal entities" do
    before do
      @entity1 = Factory(:user)
      @entity2 = Factory(:user)
      @entity3 = Factory(:user)
      @recipients = Array.new
      @recipients << @entity2
      @recipients << @entity3
    end
    
    describe "message sending" do    
      
      before do
        @mail1 = @entity1.send_message(@recipients,"Body","Subject")
        @message1 = @mail1.mailboxer_message
      end
      
      it "should create proper message" do
        @message1.sender.id.should == @entity1.id
        @message1.sender.class.should == @entity1.class
        assert @message1.body.eql?"Body"
        assert @message1.subject.eql?"Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mails
        @recipients.each do |receiver|
          mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,receiver.id,receiver.class])
          assert mail
          if mail
            mail.read.should==false
            mail.trashed.should==false
            mail.mailbox_type.should=="inbox"
          end
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message1.get_recipients
        recipients.count.should==3
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
        recipients.count(@entity3).should==1
      end
      
    end
    
    describe "message replying to sender" do
      before do
        @mail1 = @entity1.send_message(@recipients,"Body","Subject")
        @mail2 = @entity2.reply_to_sender(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
        
        #No Receiver, No Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity3.id,@entity3.class])
        assert mail.nil?
        
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
        recipients.count(@entity3).should==0
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
    
    describe "message replying to all" do
      before do
        @mail1 = @entity1.send_message(@recipients,"Body","Subject")
        @mail2 = @entity2.reply_to_all(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
        @recipients2 = Array.new
        @recipients2 << @entity1
        @recipients2 << @entity3
        
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mails
        @recipients2.each do |receiver|
          mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,receiver.id,receiver.class])
          assert mail
          if mail
            mail.read.should==false
            mail.trashed.should==false
            mail.mailbox_type.should=="inbox"
          end
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==3
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
        recipients.count(@entity3).should==1
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
  end
  
  describe "three different entities" do
    before do
      @entity1 = Factory(:user)
      @entity2 = Factory(:duck)
      @entity3 = Factory(:cylon)
      @recipients = Array.new
      @recipients << @entity2
      @recipients << @entity3
    end
    
    describe "message sending" do    
      
      before do
        @mail1 = @entity1.send_message(@recipients,"Body","Subject")
        @message1 = @mail1.mailboxer_message
      end
      
      it "should create proper message" do
        @message1.sender.id.should == @entity1.id
        @message1.sender.class.should == @entity1.class
        assert @message1.body.eql?"Body"
        assert @message1.subject.eql?"Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mails
        @recipients.each do |receiver|
          mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message1.id,receiver.id,receiver.class])
          assert mail
          if mail
            mail.read.should==false
            mail.trashed.should==false
            mail.mailbox_type.should=="inbox"
          end
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message1.get_recipients
        recipients.count.should==3
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
        recipients.count(@entity3).should==1
      end
      
    end
    
    describe "message replying to sender" do
      before do
        @mail1 = @entity1.send_message(@recipients,"Body","Subject")
        @mail2 = @entity2.reply_to_sender(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity1.id,@entity1.class])
        assert mail
        if mail
          mail.read.should==false
          mail.trashed.should==false
          mail.mailbox_type.should=="inbox"
        end
        
        #No Receiver, No Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity3.id,@entity3.class])
        assert mail.nil?
        
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==2
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
        recipients.count(@entity3).should==0
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
    
    describe "message replying to all" do
      before do
        @mail1 = @entity1.send_message(@recipients,"Body","Subject")
        @mail2 = @entity2.reply_to_all(@mail1,"Reply body")
        @message1 = @mail1.mailboxer_message
        @message2 = @mail2.mailboxer_message
        @recipients2 = Array.new
        @recipients2 << @entity1
        @recipients2 << @entity3
        
      end
      
      it "should create proper message" do
        @message2.sender.id.should == @entity2.id
        @message2.sender.class.should == @entity2.class
        assert @message2.body.eql?"Reply body"
        assert @message2.subject.eql?"RE: Subject"
      end
      
      it "should create proper mails" do
        #Sender Mail
        mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,@entity2.id,@entity2.class])
        assert mail
        if mail
          mail.read.should==true
          mail.trashed.should==false
          mail.mailbox_type.should=="sentbox"
        end      
        #Receiver Mails
        @recipients2.each do |receiver|
          mail = MailboxerMail.find(:first,:conditions=>["mailboxer_message_id=? AND receiver_id=? AND receiver_type=?",@message2.id,receiver.id,receiver.class])
          assert mail
          if mail
            mail.read.should==false
            mail.trashed.should==false
            mail.mailbox_type.should=="inbox"
          end
        end
      end
      
      it "should have the correct recipients" do
        recipients = @message2.get_recipients
        recipients.count.should==3
        recipients.count(@entity1).should==1
        recipients.count(@entity2).should==1
        recipients.count(@entity3).should==1
      end
      
      it "should be associated to the same conversation" do
        @message1.mailboxer_conversation.id.should==@message2.mailboxer_conversation.id      
      end           
    end
  end
end