require 'spec_helper'

describe Month do
  describe "#completed" do
    context "with billable project" do
      let(:budgeted_project)  { Project.new.stub(:completed => 5,
                                                 :billable  => true,
                                                 :budget    => 3) }
      let(:unbudgeted_project){ Project.new.stub(:completed => 5,
                                                 :billable  => true,
                                                 :budget    => 0) }
      it "should include project with budget > 0" do
        month = Month.new( :projects => [ budgeted_project ] ) 
        month.completed.should == 5
      end

      it "should include project with 0 budget" do
        month = Month.new( :projects => [ unbudgeted_project ] ) 
        month.completed.should == 5
      end
    end

    context "with non-billable project" do
      let(:budgeted_project)  { Project.new.stub(:completed => 5,
                                                 :billable  => false,
                                                 :budget    => 3) }
      let(:unbudgeted_project){ Project.new.stub(:completed => 5,
                                                 :billable  => false,
                                                 :budget    => 0) }
      it "should include project with budget > 0" do
        month = Month.new( :projects => [ budgeted_project ] ) 
        month.completed.should == 5
      end

      it "should not include project with 0 budget" do
        month = Month.new( :projects => [ unbudgeted_project ] ) 
        month.completed.should == 0
      end
    end

    context "other" do
      it "should include other" do
        month = Month.new( :projects => [ ],
                           :other    => Project.new.stub(:completed => 5) )
        month.completed.should == 5
      end
    end

    context "with no projects" do
      it "should return 0" do
        Month.new.completed.should == 0
      end
    end
  end
end
      
