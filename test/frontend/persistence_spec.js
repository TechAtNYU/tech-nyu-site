"use strict";

describeComponent('persistence', function() {
	beforeEach(setupComponent);
	afterEach(function() {
		$.storage.removeItem('feeds', 'localStorage');
	});

	it("should attempt to store an array of feeds via `storeFeed`", function() {
		spyOn($.storage, 'setItem');

		this.component.storeFeeds(['firstFeed', 'secondFeed']);
		expect($.storage.setItem).toHaveBeenCalled();
		expect($.storage.setItem.mostRecentCall.args[1]).toBe(JSON.stringify(['firstFeed', 'secondFeed']));
	});

	it("should retrieve stored items via `getStoredFeeds`", function() {
		spyOn($.storage, 'getItem');

		this.component.getStoredFeeds();
		expect($.storage.getItem).toHaveBeenCalled();
	});

	it("should retrieve an object equivalent to the one stored", function() {
		this.component.storeFeeds(['a feed', 'another feed']);
		expect(this.component.getStoredFeeds()).toEqual(['a feed', 'another feed']);
	});

	it("should respond to 'initializeApp' by triggering 'addFeed' with stored feeds", function() {
		this.component.storeFeeds(['http://feeds.com/init1.rss', 'http://feeds.com/init2.rss']);
		var spy = spyOnEvent(document, 'addFeed');

		this.component.trigger('initializeApp');
		expect(spy.calls.map(function(call) { return call.args[1].feedUrl; }).sort()).
			toEqual(['http://feeds.com/init1.rss', 'http://feeds.com/init2.rss'].sort());
	});

	describe("while the app is running", function() {
		it("should respond to the 'addFeed' event by storing the feed", function() {
			this.component.trigger('addFeed', {feedUrl: 'http://feeds.com/rss'});

			expect(this.component.getStoredFeeds()).toEqual(['http://feeds.com/rss']);
		});

		it("should respond to the 'removeFeed' event by removing the feed from storage", function() {
			this.component.trigger('addFeed', {feedUrl: 'http://feeds.com/rss1'});
			this.component.trigger('addFeed', {feedUrl: 'http://feeds.com/rss2'});

			expect(this.component.getStoredFeeds().length).toBe(2);

			this.component.trigger('removeFeed', {feedUrl: 'http://feeds.com/rss2'});
			expect(this.component.getStoredFeeds()).toEqual(['http://feeds.com/rss1']);
		});
	});
});
