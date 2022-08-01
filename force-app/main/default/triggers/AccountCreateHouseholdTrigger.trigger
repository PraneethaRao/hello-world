trigger AccountCreateHouseholdTrigger on Account (after insert, after Update) {
	AccountCreateHousehold.create(Trigger.New);
}