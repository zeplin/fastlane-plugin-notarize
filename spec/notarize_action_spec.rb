describe Fastlane::Actions::NotarizeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with('Notarize plugin is working!')

      Fastlane::Actions::NotarizeAction.run(nil)
    end
  end
end
