require 'present/entity'

module Present
  describe Entity do

    let(:basic) do
      Class.new(Entity) do
        expose :name
        expose :age
      end
    end

    let(:object) { double(:user, name: 'Bob', age: 5, gender: 'f') }
    let(:presentable) { basic.new(object) }
    subject { presentable }

    its(:name) { should eq 'Bob' }
    its(:age) { should eq 5 }
    it { should_not respond_to :gender }

    its(:to_h) { should include :name, :age }
    its(:to_h) { should_not include :gender }

    it 'should do the same thing with represent' do
      basic.represent(object).should == {name: 'Bob', age: 5}
    end

    it 'should return nil when presenting nil' do
      basic.represent(nil).should be_nil
    end

    describe 'presentable that inherits' do
      let(:inherited) do
        Class.new(basic) do
          def gender
            object.gender.upcase
          end
        end
      end
      let(:presentable) { inherited.new(object) }
      subject { presentable }

      its(:name) { should eq 'Bob' }
      its(:age) { should eq 5 }
      its(:gender) { should eq 'F' }

      its(:to_h) { should include :name, :age, :gender }
    end

  end
end
