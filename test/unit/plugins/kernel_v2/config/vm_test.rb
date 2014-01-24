require File.expand_path("../../../../base", __FILE__)

require Vagrant.source_root.join("plugins/kernel_v2/config/vm")

describe VagrantPlugins::Kernel_V2::VMConfig do
  subject { described_class.new }

  let(:machine) { double("machine") }

  def assert_valid
    errors = subject.validate(machine)
    if !errors.values.all? { |v| v.empty? }
      raise "Errors: #{errors.inspect}"
    end
  end

  before do
    machine.stub(provider_config: nil)

    subject.box = "foo"
  end

  it "is valid with test defaults" do
    subject.finalize!
    assert_valid
  end

  context "#box_check_update" do
    it "defaults to nil" do
      subject.finalize!

      expect(subject.box_check_update).to be_nil
    end
  end

  context "#box_url" do
    it "defaults to nil" do
      subject.finalize!

      expect(subject.box_url).to be_nil
    end

    it "turns into an array" do
      subject.box_url = "foo"
      subject.finalize!

      expect(subject.box_url).to eq(
        ["foo"])
    end

    it "keeps in array" do
      subject.box_url = ["foo", "bar"]
      subject.finalize!

      expect(subject.box_url).to eq(
        ["foo", "bar"])
    end
  end

  context "#box_version" do
    it "defaults to >= 0" do
      subject.finalize!

      expect(subject.box_version).to eq(">= 0")
    end

    it "errors if invalid version" do
      subject.box_version = "nope"
      subject.finalize!

      expect { assert_valid }.to raise_error(RuntimeError)
    end

    it "can have complex constraints" do
      subject.box_version = ">= 0, ~> 1.0"
      subject.finalize!

      assert_valid
    end
  end
end
