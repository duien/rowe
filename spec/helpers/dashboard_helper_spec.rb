require 'spec_helper'

describe DashboardHelper do
  describe '#more_text' do
    before { Timecop.freeze(Date.civil(2011, 03, 28)) }
    after { Timecop.return }
    subject { helper.more_text(project) }

    context 'behind schedule' do
      let(:project) { Factory(:needs_catchup_project) }
      it { should =~ /1:15 by end of day/ }
    end

    context 'ahead of schedule' do
      let(:project) { Factory(:ahead_project) }
      it { should =~ /0:45 ahead/ }
    end
  end
end

