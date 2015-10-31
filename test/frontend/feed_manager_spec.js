"use strict";

describeComponent('feed-manager', function() {
	var SUBMIT_BUTTONS = [
		// buttons default to `type="submit"` when `type` is absent
		'button:not([type])',
		// include buttons with an explicit `type="submit"`
		'button[type="submit"]',
		// inputs of type "submit"
		'input[type="submit"]'
	];
	var FEED_URL = 'http://localhost/not-a-real-feed.rss';

	beforeEach(function() {
		setupComponent();

		/**
		 * Helper function to mimic "submitting a feed"
		 */
		this.submitFeed = function(feed) {
			this.component.$node.find('input[type="url"]').val(feed);
			this.component.$node.find(SUBMIT_BUTTONS.join(',')).click();
		}.bind(this);
	});

	it("should present the user with a way to enter a new feed", function() {
		expect(this.component.$node.find('form')).toExist();
		expect(this.component.$node.find('input[type="url"]')).toExist();
		expect(this.component.$node.find(SUBMIT_BUTTONS.join(','))).toExist();
	});

	it("should add a new feed to the list when the user submits the form", function() {
		var feed = this.component.select('feedItem');
		// there should be no feeds to start
		expect(feed).not.toExist();

		// add a feed
		this.submitFeed(FEED_URL);

		// now there should be a feed with the specified url in the component
		feed = this.component.select('feedItem');
		expect(feed.length).toBe(1);
		expect(feed.find('.url').text()).toEqual(FEED_URL);
	});

	it("should remove a feed from the list when the 'remove' button is clicked", function() {
		var feed;
		// add a feed
		this.submitFeed(FEED_URL);

		feed = this.component.select('feedItem');
		expect(feed.length).toBe(1);
		feed.find('.remove').click();

		feed = this.component.select('feedItem');
		expect(feed).not.toExist();
	});

	it("should clear the form when a new feed is submitted", function() {
		var $input = this.component.$node.find('input[type="url"]');
		expect($input.val()).toBe('');
		// go through the add feed process
		this.submitFeed(FEED_URL);
		expect($input.val()).toBe('');
	});

	it("should emit a 'addFeed' event when a feed is added", function() {
		// Create an event listener and attach it to the
		// document object to listen for our custom event
		var eventSpy = spyOnEvent(document, 'addFeed');

		// Add the feed
		this.submitFeed(FEED_URL);

		// verify our event listener was called and the
		// correct data was given
		expect(eventSpy).toHaveBeenTriggeredOn(document);
		expect(eventSpy.mostRecentCall.args[1]).toEqual({
			feedUrl: FEED_URL
		});
	});

	it("should respond to the 'addFeed' event by adding a feed to the list", function() {
		expect(this.component.select('feedItem')).not.toExist();

		this.component.trigger('addFeed', {feedUrl: FEED_URL});

		expect(this.component.select('feedItem').length).toBe(1);
	});

	it("should emit a 'removeFeed' event when a feed is removed", function() {
		// Create an event listener and attach it to the
		// document object to listen for our custom event
		var eventSpy = spyOnEvent(document, 'removeFeed');

		// Add the feed
		this.submitFeed(FEED_URL);

		// verify our event listener has not been called yet
		expect(eventSpy).not.toHaveBeenTriggeredOn(document);

		// remove the feed
		this.component.select('feedItem').find('.remove').click();

		// verify the event listener was called with the correct
		// feed data
		expect(eventSpy).toHaveBeenTriggeredOn(document);
		expect(eventSpy.mostRecentCall.args[1]).toEqual({
			feedUrl: FEED_URL
		});
	});

	it("should respond to the 'removeFeed' event by removing a feed from the list", function() {
		this.submitFeed(FEED_URL);
		expect(this.component.select('feedItem').length).toBe(1);
		this.component.trigger('removeFeed', {feedUrl: FEED_URL});
		expect(this.component.select('feedItem')).not.toExist();
	});

	it("should respond to 'addFeed' by emitting a 'uiNeedsFeedInfo' event", function() {
		var eventSpy = spyOnEvent(document, 'uiNeedsFeedInfo');

		this.component.trigger('addFeed', {feedUrl: FEED_URL});
		expect(eventSpy).toHaveBeenTriggeredOn(document);
		expect(eventSpy.mostRecentCall.data).toEqual({
			feedUrl: FEED_URL
		});
	});

	it("should respond to 'dataFeedInfo' by updating the feed title", function() {
		// submit 2 feeds
		var feed1 = 'http://127.0.0.1/feed-1';
		var feed2 = 'http://127.0.0.1/feed-2';
		this.submitFeed(feed1);
		this.submitFeed(feed2);

		// verify both are in the table
		expect(this.component.select('feedItem').length).toBe(2);

		// trigger the event in question
		this.component.trigger('dataFeedInfo', {
			feedUrl: feed2,
			title: "The Feed Title"
		});

		// verify that feed-1 does not have a title, but feed-2 does
		expect(this.component.select('feedItem').filter(function() {
			return $(this).find('.url').text() == feed1;
		}).find('.title').text()).toBe('');
		expect(this.component.select('feedItem').filter(function() {
			return $(this).find('.url').text() == feed2;
		}).find('.title').text()).toBe("The Feed Title");
	});
});
