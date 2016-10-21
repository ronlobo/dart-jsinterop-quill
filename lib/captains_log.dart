import 'dart:html';

import 'package:captains_log/quill.dart' as quill;

// ignoring leap years
const int _secondsInAYear = 31536000;
const String _prompt = 'Something happened. Make it sound puzzling and heroic.';
final List<String> _templates = [
  'We encountered what appeared to be a <insert space anomaly>. It has '
      'proven to be sentient and has taken control of our ship. Thus far, all '
      'efforts at communication have failed.... HELP!',
  'A warship from the <insert hostile alien organization> has entered our '
      'territory. It is currently speeding towards Earth. Thus far, all '
      'efforts at peace have failed...',
  'The ship has been pulled into a <insert type of time distortion>. We are '
      'observing the universe in the distant <past or future>. Thus far, all '
      'efforts to return to our timeline have failed...'
];

quill.QuillStatic quillEditor;
Map<double, HtmlElement> logEntries;
HtmlElement logElement;

init() {
  // clear previous state if any
  // uninstall();

  // initialization
  quillEditor = new quill.QuillStatic('#editor',
      new quill.QuillOptionsStatic(theme: "bubble", placeholder: _prompt));
  logElement = document.getElementById('log');
  logEntries = new Map<double, HtmlElement>();
  loadPreviousEntries();

  // listeners
  document.getElementById('save').onClick.listen(saveLog);
  document.getElementById('clear').onClick.listen(_clearLog);
  (document.getElementById('templateSelect') as SelectElement)
      ..onChange.listen(useTemplate);
}

HtmlElement _clearListeners(HtmlElement element) {
  var newElement = element.clone(true);
  return element.replaceWith(newElement);
}

void _clearLog(e) {
  window.localStorage.clear();
  logElement.nodes.clear();
}

uninstall() {
  document.querySelectorAll('.ql-toolbar').forEach((e) => e.remove());
  _clearListeners(document.getElementById('save'));
  _clearListeners(document.getElementById('clear'));
  _clearListeners(document.getElementById('templateSelect'));
}

// This function will be removed. It is just holding some example dart that
// should be executed in the console.
temporary() {
  document.body.style
    ..backgroundImage = "url(https://cdn.spacetelescope.org/archives/images/wallpaper2/heic0601a.jpg)"
    ..setProperty('background-size', '100% 100%')
    ..setProperty('background-attachment', 'fixed');
}

/// Capture entry in editor, save to local storage and display in log.
void appendToLog(double stardate, HtmlElement logEntryElement) {
  logEntries[stardate] = logEntryElement;
  window.localStorage[stardate.toString()] = logEntryElement.innerHtml;
  displayLogEntry(stardate, logEntryElement);
}

/// Calculate the current stardate: <Year>.<Percentage of year completion>
double calculateStardate() {
  var now = new DateTime.now();
  var beginningOfYear = new DateTime(now.year);
  int secondsThisYear = now.difference(beginningOfYear).inSeconds;
  return now.year + secondsThisYear / _secondsInAYear;
}

/// Copy html elements from the editor view and return them inside a new
/// DivElement.
HtmlElement captureEditorView() {
  Element contentElement = document.getElementById('editor').firstChild;

  var logEntryElement = new DivElement()
    ..innerHtml = contentElement.innerHtml;

  return logEntryElement;
}

void displayLogEntry(double stardate, HtmlElement logEntryElement) {
  if (logElement.children.isNotEmpty) {
    logElement.insertAdjacentElement('afterBegin', new HRElement());
  }

  logElement.insertAdjacentElement('afterBegin', logEntryElement);
  var stardateElement = new HeadingElement.h2()
    ..text = 'Stardate: $stardate'
    ..classes.add('stardate');
  logElement.insertAdjacentElement('afterBegin', stardateElement);
}

/// Load all log entries from browser local storage.
void loadPreviousEntries() {
//  Element logElement = document.getElementById('log');
  logElement.innerHtml = window.localStorage['log'] ?? '';

  List<String> keys = window.localStorage.keys.toList();
  keys.sort();
  for (String key in keys) {
    var entryElement = new DivElement()
      ..innerHtml = window.localStorage[key];
    logEntries[double.parse(key)] = entryElement;
  }
  updateDisplay();
}

/// Save the log entry that is currently in the editor.
void saveLog(Event _) {
  DivElement logEntryElement = captureEditorView();
  appendToLog(calculateStardate(), logEntryElement);

  // Clear the editor.
  quillEditor.deleteText(0, quillEditor.getLength());
}

void updateDisplay() {
  logElement.innerHtml = '';
  List<double> keys = logEntries.keys.toList();
  keys.sort();
  for (double key in keys) {
    displayLogEntry(key, logEntries[key]);
  }
}

/// Updates the content of the editor using the selected template.
void useTemplate(Event _) {
  SelectElement templateSelectElement =
  document.getElementById('templateSelect');
  int selectedIndex = templateSelectElement.selectedIndex;

  if (selectedIndex == 0) return;

  quillEditor.deleteText(0, quillEditor.getLength());
  String templateText = _templates[templateSelectElement.selectedIndex - 1];
  quillEditor.insertText(0, templateText, 'api');
}
