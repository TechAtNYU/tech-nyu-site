"use strict";

describeMixin('mixin-markup', function() {
	it("should insert the markup in the 'template' attribute when the component is initialized", function() {
		setupComponent({
			"template": '<span class="ok"></span>'
		});

		expect(this.component.$node.html()).toBe('<span class="ok"></span>');
	});
});
