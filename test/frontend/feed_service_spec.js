"use strict";

describeComponent('feed-service', function() {
	var FEED_URL = 'http://not.a.feed.com/feed.rss';

	beforeEach(setupComponent);

	it("should respond to 'uiNeedsFeedInfo' events with 'dataFeedInfo'", function() {
		var eventData = spyOnEvent(document, 'dataFeedInfo');

		// intercept the 'executeRequest' method and just call through
		spyOn(this.component, 'executeRequest').andCallFake(function(url, callback) {
			callback.call(this, {
				feed : {
					feedUrl: url,
					title: "The Feed Name"
				}
			});
		});

		this.component.trigger('uiNeedsFeedInfo', { feedUrl: FEED_URL });
		expect(eventData).toHaveBeenTriggeredOn(document);
		expect(eventData.mostRecentCall.data).toEqual({
			feedUrl: FEED_URL,
			title: "The Feed Name"
		});
	});

	it("should call the Google Feed API with the feed URL", function() {
		// need a mock object for Google. We don't want to ping
		// the server for our unit tests!
		var feedSpy = jasmine.createSpy();
		var loadSpy = jasmine.createSpy();
		feedSpy.prototype.load = loadSpy;
		// make it available globally under the right namespace
		window.google = { feeds: { Feed: feedSpy } };

		// trigger the event to start the process
		this.component.trigger('uiNeedsFeedInfo', { feedUrl: FEED_URL });
		// we should have created a new feed
		expect(window.google.feeds.Feed.mostRecentCall.object instanceof feedSpy).toBeTruthy();
		expect(window.google.feeds.Feed).toHaveBeenCalledWith(FEED_URL);
		// and we should have invoked the load method with a function
		expect(loadSpy).toHaveBeenCalled();
		expect(typeof loadSpy.mostRecentCall.args[0]).toBe('function');
	});

	it("should emit the 'dataFeedInfo' event with the feed data as the data argument", function() {
		// we don't need to inspect our mocks for this test
		function Feed(url) {
			this.url = url;
		}
		Feed.prototype.load = function(callback) {
			// provide some data that looks like the response format of the Google Feed API
			callback({
				feed: {
					feedUrl: this.url,
					title: "Dummy Title"
				}
			});
		};
		// make it available globally under the right namespace
		window.google = { feeds: { Feed: Feed } };

		// we want to listen for globally fired events
		var eventSpy = spyOnEvent(document, 'dataFeedInfo');

		// trigger the event to start the process
		this.component.trigger('uiNeedsFeedInfo', { feedUrl: FEED_URL });

		// expect our event to have been triggered with the same data
		expect(eventSpy).toHaveBeenTriggeredOn(document);
		expect(eventSpy.mostRecentCall.data).toEqual({
			feedUrl: FEED_URL,
			title: "Dummy Title"
		});
	});
});
