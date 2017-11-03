describe("Settings", function() {
  var Settings = require('hyrax/admin/collection_type/settings');
  var target = null;
  var element = null;
  var form = null;

  beforeEach(function() {
    var fixture = setFixtures(settingsForm());
    element = fixture.find("input[type='checkbox'][name$='[sharable]']");
    form = element.closest('form');
    target = new Settings($('form'));
  });

  //sharableChanged
  describe("sharableChanged", function() {
    describe("with sharable checked", function() {
      beforeEach(function() {
        form.find("input[type='checkbox'][name$='[sharable]']").prop("checked", true).prop("disabled", false);
      });
      it("share_applies_to options are enabled", function() {
        target.sharableChanged();
        expect(form.find("[type='radio'][value='collection']")).not.toBeChecked();
        expect(form.find("[type='radio'][value='collection']")).not.toBeDisabled();
        expect(form.find("[type='radio'][value='new_works']")).not.toBeChecked();
        expect(form.find("input[type='radio'][value='new_works']")).not.toBeDisabled();
        expect(form.find("[type='radio'][value='collection_and_new_works']")).toBeChecked();
        expect(form.find("[type='radio'][value='collection_and_new_works']")).not.toBeDisabled();
      });
    });
    describe("with sharable unchecked", function() {
      beforeEach(function() {
        form.find("input[type='checkbox'][name$='[sharable]']").prop("checked", false).prop("disabled", false);
      });
      it("share_applies_to options are disabled", function() {
        target.sharableChanged();
        expect(form.find("[type='radio'][value='collection']")).not.toBeChecked();
        expect(form.find("[type='radio'][value='collection']")).toBeDisabled();
        expect(form.find("[type='radio'][value='new_works']")).not.toBeChecked();
        expect(form.find("[type='radio'][value='new_works']")).toBeDisabled();
        expect(form.find("[type='radio'][value='collection_and_new_works']")).toBeChecked();
        expect(form.find("[type='radio'][value='collection_and_new_works']")).toBeDisabled();
      });
    });
  });
});

// Generate a form that collection type settings
function settingsForm() {
    return '<form class="simple_form edit_collection_type" id="edit_collection_type" action="/admin/collection_types/3?locale=en" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="patch" /><input type="hidden" name="authenticity_token" value="2Si+G8crN9SzhkKeVUl6gAZofiPFvm49ma998urlMgtW5fHbfzQlv71P9y8i8LybucAc3AkSrk9uwnF99jmz0A==" />' +
        '  <div class="tab-content">' +
        '    <div id="settings" class="tab-pane">' +
        '      <div class="panel panel-default labels">' +
        '        <div class="panel-body">' +
        '          <p>These settings determine how collections of this type can be managed and discovered.</p>' +
        '          <p><strong>Warning: These settings cannot be changed after a collection of this type has been created.</strong></p>' +
        '          <div class="collection-types-settings">' +
        '            <div class="form-inline">' +
        '              <p><div class="form-group boolean optional collection_type_nestable"><div class="checkbox"><input value="0" type="hidden" name="collection_type[nestable]" /><label class="boolean optional" for="collection_type_nestable"><input class="boolean optional" type="checkbox" value="1" checked="checked" name="collection_type[nestable]" id="collection_type_nestable" />NESTABLE</label></div><p class="help-block">Allow collections of this type to be nested (a collection can contain other collections)</p></div></p>' +
        '              <p><div class="form-group boolean optional collection_type_discoverable"><div class="checkbox"><input value="0" type="hidden" name="collection_type[discoverable]" /><label class="boolean optional" for="collection_type_discoverable"><input class="boolean optional" type="checkbox" value="1" checked="checked" name="collection_type[discoverable]" id="collection_type_discoverable" />DISCOVERY</label></div><p class="help-block">Allow collections of this type to be discoverable</p></div></p>' +
        '              <p><div class="form-group boolean optional collection_type_sharable"><div class="checkbox"><input value="0" type="hidden" name="collection_type[sharable]" /><label class="boolean optional" for="collection_type_sharable"><input class="boolean optional" type="checkbox" value="1" checked="checked" name="collection_type[sharable]" id="collection_type_sharable" />SHARING</label></div><p class="help-block">Allow users to assign collection managers, depositors, and viewers for collections they manage</p></div></p>' +
        '              <p></p>' +
        '              <div class="form-group collection_type_share_applies_to">' +
        '                <div class="radio">' +
        '                  <label>' +
        '                    <input type="radio" value="collection" name="collection_type[share_applies_to]" id="collection_type_share_applies_to_collection" />' +
        '                        APPLY TO COLLECTION' +
        '                  </label>' +
        '                </div>' +
        '                <p class="help-block">When changes to sharing participants are made, grant those users and groups permissions for the collection.</p>' +
        '              </div>' +
        '              <p></p>' +
        '              <div class="form-group collection_type_share_applies_to">' +
        '                <div class="radio">' +
        '                  <label>' +
        '                    <input type="radio" value="new_works" name="collection_type[share_applies_to]" id="collection_type_share_applies_to_new_works" />' +
        '                        APPLY TO NEW WORKS' +
        '                  </label>' +
        '                </div>' +
        '                <p class="help-block collection_type_share_applies_to">When new works are created directly in the collection, grant sharing participants users and groups permissions for the new work.</p>' +
        '              </div>' +
        '              <p></p>' +
        '              <div class="form-group collection_type_share_applies_to">' +
        '                <div class="radio">' +
        '                  <label>' +
        '                    <input type="radio" value="collection_and_new_works" checked="checked" name="collection_type[share_applies_to]" id="collection_type_share_applies_to_collection_and_new_works" />' +
        '                        BOTH' +
        '                  </label>' +
        '                </div>' +
        '                <p class="help-block"></p>' +
        '              </div>' +
        '              <p><div class="form-group boolean optional collection_type_allow_multiple_membership"><div class="checkbox"><input value="0" type="hidden" name="collection_type[allow_multiple_membership]" /><label class="boolean optional" for="collection_type_allow_multiple_membership"><input class="boolean optional" type="checkbox" value="1" checked="checked" name="collection_type[allow_multiple_membership]" id="collection_type_allow_multiple_membership" />MULTIPLE MEMBERSHIP</label></div><p class="help-block">Allow works to belong to multiple collections of this type</p></div></p>' +
        '              <p><div class="form-group boolean optional disabled collection_type_require_membership"><div class="checkbox"><input value="0" disabled="disabled" type="hidden" name="collection_type[require_membership]" /><label class="boolean optional disabled" for="collection_type_require_membership"><input class="boolean optional disabled" disabled="disabled" type="checkbox" value="1" name="collection_type[require_membership]" id="collection_type_require_membership" />REQUIRE MEMBERSHIP</label></div><p class="help-block">A work must belong to at least one collection of this type</p></div></p>' +
        '              <p><div class="form-group boolean optional disabled collection_type_assigns_workflow"><div class="checkbox"><input value="0" disabled="disabled" type="hidden" name="collection_type[assigns_workflow]" /><label class="boolean optional disabled" for="collection_type_assigns_workflow"><input class="boolean optional disabled" disabled="disabled" type="checkbox" value="1" name="collection_type[assigns_workflow]" id="collection_type_assigns_workflow" />WORKFLOW</label></div><p class="help-block">Allow collections of this type to assign workflow to a new work</p></div></p>' +
        '              <p><div class="form-group boolean optional disabled collection_type_assigns_visibility"><div class="checkbox"><input value="0" disabled="disabled" type="hidden" name="collection_type[assigns_visibility]" /><label class="boolean optional disabled" for="collection_type_assigns_visibility"><input class="boolean optional disabled" disabled="disabled" type="checkbox" value="1" name="collection_type[assigns_visibility]" id="collection_type_assigns_visibility" />VISIBILITY</label></div><p class="help-block">Allow collections of this type to assign initial visibility settings to a new work</p></div></p>' +
        '            </div>' +
        '          </div>' +
        '        </div>' +
        '      </div>' +
        '    </div>' +
        '    <div class="panel-footer">' +
        '      <input type="submit" name="update_collection_type" value="Save changes" class="btn btn-primary" onclick="confirmation_needed = false;" id="update_submit" data-disable-with="Save changes" />' +
        '      <a class="btn btn-link" href="/admin/collection_types?locale=en">Cancel</a>' +
        '    </div>' +
        '  </div>' +
        '</form>';
}

