import 'package:flutter/material.dart';

class HighlightText extends StatelessWidget {
  /// The query string to search for or highlight within the [source].
  /// Example: "example"
  final String query;

  /// The source text in which to search for or highlight occurrences of [query].
  /// Example: "This is an example of text highlighting."
  final String source;

  /// The color used to highlight the matched text.
  /// Example: Colors.yellow.shade700
  final Color highlightColor;

  /// Optional text style applied to the entire [source] text.
  /// Example: TextStyle(fontWeight: FontWeight.bold)
  final TextStyle? textStyle;

  /// Optional text style applied to the matched portions of the [source] text.
  /// Example: TextStyle(fontStyle: FontStyle.italic)
  final TextStyle? matchedTextStyle;

  /// Specifies whether the search for [query] should be case-sensitive.
  /// Defaults to `false`.
  /// Example: true
  final bool? caseSensitive;

  /// Indicates if multiple queries from [queries] are being highlighted.
  /// Example: true
  final bool isMultiple;

  /// Indicates if regular expression matching using [regex] is enabled.
  /// Example: true
  final bool isRegex;

  /// The regular expression pattern used for matching within [source].
  /// Example: r'\b\d{4}\b'
  final String regex;

  /// List of query strings to highlight within [source], used when [isMultiple] is `true`.
  /// Example: ['highlight', 'text', 'example']
  final List<String> queries;

  /// Constructs a `HighlightText` widget for highlighting a single query within a source text.
  ///
  /// Required Parameters:
  /// - [query]: The string to search for and highlight within [source].
  /// - [source]: The text in which to search for occurrences of [query].
  ///
  /// Optional Parameters:
  /// - [textStyle]: Optional text style applied to the entire [source] text.
  /// - [matchedTextStyle]: Optional text style applied to the matched portions of the [source] text.
  /// - [highlightColor]: The color used to highlight the matched text. Defaults to Colors.red.
  /// - [caseSensitive]: Specifies whether the search for [query] should be case-sensitive. Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// HighlightText(
  ///   query: "example",
  ///   source: "This is an example of text highlighting.",
  ///   highlightColor: Colors.yellow.shade700,
  ///   matchedTextStyle: TextStyle(fontStyle: FontStyle.italic),
  ///   textStyle: TextStyle(fontWeight: FontWeight.bold),
  /// );
  /// ```
  HighlightText({
    super.key,
    required this.query,
    required this.source,
    this.textStyle,
    this.matchedTextStyle,
    this.highlightColor = Colors.red,
    this.caseSensitive = false,
  })  : isMultiple = false,
        isRegex = false,
        regex = '',
        queries = [];

  /// Constructs a `HighlightText` widget for highlighting multiple queries within a source text.
  ///
  /// Required Parameters:
  /// - [queries]: List of strings to search for and highlight within [source].
  /// - [source]: The text in which to search for occurrences of any query in [queries].
  ///
  /// Optional Parameters:
  /// - [textStyle]: Optional text style applied to the entire [source] text.
  /// - [matchedTextStyle]: Optional text style applied to the matched portions of the [source] text.
  /// - [highlightColor]: The color used to highlight the matched text. Defaults to Colors.red.
  /// - [caseSensitive]: Specifies whether the search for queries should be case-sensitive. Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// HighlightText.multiple(
  ///   queries: ['highlight', 'text', 'example'],
  ///   source: "This is an example of highlighting multiple queries.",
  ///   highlightColor: Colors.yellow.shade700,
  ///   matchedTextStyle: TextStyle(fontStyle: FontStyle.italic),
  ///   textStyle: TextStyle(fontWeight: FontWeight.bold),
  /// );
  /// ```
  const HighlightText.multiple({
    super.key,
    required this.queries,
    required this.source,
    this.textStyle,
    this.matchedTextStyle,
    this.highlightColor = Colors.red,
    this.caseSensitive = false,
  })  : isMultiple = true,
        isRegex = false,
        regex = '',
        query = '';

  ///
  /// Required Parameters:
  /// - [source]: The text in which to search for matches using [regex].
  /// - [regex]: The regular expression pattern used to find matches within [source].
  ///
  /// Optional Parameters:
  /// - [textStyle]: Optional text style applied to the entire [source] text.
  /// - [matchedTextStyle]: Optional text style applied to the matched portions of the [source] text.
  /// - [highlightColor]: The color used to highlight the matched text. Defaults to Colors.red.
  /// - [caseSensitive]: Specifies whether the regex matching should be case-sensitive. Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// HighlightText.regex(
  ///   regex: r'\b\d{4}\b',
  ///   source: "The years 2023, 2024, and 2025 are important.",
  ///   highlightColor: Colors.yellow.shade700,
  ///   matchedTextStyle: TextStyle(fontStyle: FontStyle.italic),
  ///   textStyle: TextStyle(fontWeight: FontWeight.bold),
  /// );
  /// ```

  HighlightText.regex({
    super.key,
    required this.source,
    required this.regex,
    this.textStyle,
    this.matchedTextStyle,
    this.highlightColor = Colors.red,
    this.caseSensitive = false,
  })  : isMultiple = false,
        isRegex = true,
        queries = [],
        query = '';

  /// Builds the `HighlightText` widget based on its properties and conditionally highlights text.
  ///
  /// This method constructs a `Text.rich` widget, allowing rich text formatting
  /// and conditional highlighting based on the widget's configuration.
  ///
  /// If [isRegex] is `true`, the method calls [highlightRegexMatches] to apply
  /// regex-based highlighting to the [source] text.
  ///
  /// If [isMultiple] is `true`, the method calls [highlightQueriesInString] to
  /// apply multiple query-based highlighting using [queries] on the [source] text.
  ///
  /// If neither [isRegex] nor [isMultiple] is `true`, the method calls
  /// [highlightQueryInString] to highlight a single [query] within the [source] text.
  ///
  /// Parameters:
  /// - [context]: The build context provided by the Flutter framework.
  ///
  /// Returns:
  /// A `Text.rich` widget configured with appropriate highlighting based on
  /// the widget's properties and conditions.
  ///
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: textStyle,
      isRegex
          ? highlightRegexMatches(
              source: source, highlightColor: highlightColor)
          : isMultiple
              ? highlightQueriesInString(
                  highlightColor: highlightColor,
                  queries: queries,
                  target: source,
                  matchedTextStyle: matchedTextStyle,
                )
              : highlightQueryInString(
                  highlightColor: highlightColor,
                  query: query,
                  target: source,
                  matchedTextStyle: matchedTextStyle,
                ),
    );
  }

  /// Highlights occurrences of a single query in the target text.
  ///
  /// This method searches for all occurrences of the [query] string in the [target]
  /// text and constructs a list of `TextSpan` objects. Each span represents a segment
  /// of the target text, either matching the query or non-matching.
  ///
  /// Parameters:
  /// - [query]: The string to search for and highlight within [target].
  /// - [target]: The text in which to search for occurrences of [query].
  /// - [highlightColor]: The color used to highlight the matched text.
  /// - [matchedTextStyle]: Optional text style applied to the matched portions of the [target].
  ///
  /// Returns:
  /// A `TextSpan` containing children spans with highlighted matches and non-matching text.
  ///
  /// Example:
  /// ```dart
  /// TextSpan highlightedText = highlightQueryInString(
  ///   query: "example",
  ///   target: "This is an example of text highlighting.",
  ///   highlightColor: Colors.yellow.shade700,
  ///   matchedTextStyle: TextStyle(fontStyle: FontStyle.italic),
  /// );
  /// ```
  TextSpan highlightQueryInString({
    required String query,
    required String target,
    required Color highlightColor,
    TextStyle? matchedTextStyle,
  }) {
    List<TextSpan> spans = [];
    int startIndex = 0;

    // Iterate through the target text to find all occurrences of the query
    while (startIndex < target.length) {
      int index;

      // Determine the index of the next occurrence of the query in the target text
      if (caseSensitive == true) {
        index = target.indexOf(query, startIndex);
      } else {
        index = target.toLowerCase().indexOf(query.toLowerCase(), startIndex);
      }

      // If no more matches are found, add the remaining part of the target text
      if (index == -1) {
        spans.add(TextSpan(text: target.substring(startIndex)));
        break;
      }

      // Add the text before the match if there is any
      if (index > startIndex) {
        spans.add(TextSpan(text: target.substring(startIndex, index)));
      }

      // Add the matched text with the specified highlight color and style
      spans.add(TextSpan(
        text: target.substring(index, index + query.length),
        style: matchedTextStyle?.copyWith(backgroundColor: highlightColor) ??
            TextStyle(
              backgroundColor: highlightColor,
            ),
      ));

      // Update startIndex to the end of the current match
      startIndex = index + query.length;
    }

    // Return the constructed TextSpan with all the highlighted spans
    return TextSpan(children: spans);
  }

  /// Highlights multiple queries within the target text based on provided queries.
  ///
  /// This method constructs a list of `TextSpan` objects where each span represents
  /// a segment of the target text, either matching one of the queries or non-matching.
  ///
  /// Parameters:
  /// - [queries]: List of strings to search for and highlight within [target].
  /// - [target]: The text in which to search for occurrences of any query in [queries].
  /// - [highlightColor]: The color used to highlight the matched text.
  /// - [matchedTextStyle]: Optional text style applied to the matched portions of the [target].
  ///
  /// Returns:
  /// A `TextSpan` containing children spans with highlighted matches and non-matching text.
  ///
  /// Example:
  /// ```dart
  /// TextSpan highlightedText = highlightQueriesInString(
  ///   queries: ['highlight', 'text', 'example'],
  ///   target: "This is an example of highlighting multiple queries.",
  ///   highlightColor: Colors.yellow.shade700,
  ///   matchedTextStyle: TextStyle(fontStyle: FontStyle.italic),
  /// );
  ///
  TextSpan highlightQueriesInString({
    required List<String> queries,
    required String target,
    required Color highlightColor,
    TextStyle? matchedTextStyle,
  }) {
    List<TextSpan> spans = [];
    int startIndex = 0;

    // Construct a regular expression that matches any of the queries
    String regexPattern = queries.join('|');
    RegExp regExp = RegExp(regexPattern, caseSensitive: caseSensitive ?? false);

    // Find all matches of the regular expression in the target text
    Iterable<RegExpMatch> matches = regExp.allMatches(target);

    // Iterate through each match and construct TextSpan objects accordingly
    for (RegExpMatch match in matches) {
      // Add the text before the match if there is any
      if (match.start > startIndex) {
        spans.add(TextSpan(text: target.substring(startIndex, match.start)));
      }

      // Add the matched text with the specified highlight color and style
      spans.add(TextSpan(
        text: match.group(0)!,
        style: matchedTextStyle?.copyWith(backgroundColor: highlightColor) ??
            TextStyle(backgroundColor: highlightColor),
      ));

      // Update startIndex to the end of the current match
      startIndex = match.end;
    }

    // Add any remaining text after the last match
    if (startIndex < target.length) {
      spans.add(TextSpan(text: target.substring(startIndex)));
    }

    // Return the constructed TextSpan with all the highlighted spans
    return TextSpan(children: spans);
  }

  /// Highlights text matches in the source text based on a regular expression.
  ///
  /// This method searches for all occurrences of the regular expression [regex] in
  /// the [source] text and constructs a list of `TextSpan` objects. Each span
  /// represents a segment of the source text, either matching the regex or non-matching.
  ///
  /// Parameters:
  /// - [source]: The text in which to search for occurrences of the regex.
  /// - [highlightColor]: The color used to highlight the matched text.
  /// - [matchedTextStyle]: Optional text style applied to the matched portions of the [source].
  ///
  /// Returns:
  /// A `TextSpan` containing children spans with highlighted matches and non-matching text.
  ///
  /// Example:
  /// ```dart
  /// TextSpan highlightedText = highlightRegexMatches(
  ///   source: "The years 2023, 2024, and 2025 are important.",
  ///   highlightColor: Colors.yellow.shade700,
  ///   matchedTextStyle: TextStyle(fontWeight: FontWeight.bold),
  /// );
  ///
  TextSpan highlightRegexMatches({
    required String source,
    required Color highlightColor,
    TextStyle? matchedTextStyle,
  }) {
    List<TextSpan> spans = [];
    Iterable<RegExpMatch> matches = RegExp(regex).allMatches(source);

    int startIndex = 0;

    // Iterate through each match found by the regex
    for (RegExpMatch match in matches) {
      // Add the text before the match if there is any
      if (match.start > startIndex) {
        spans.add(TextSpan(text: source.substring(startIndex, match.start)));
      }

      // Add the matched text with the specified highlight color and style
      spans.add(TextSpan(
        text: match.group(0)!,
        style: matchedTextStyle?.copyWith(backgroundColor: highlightColor) ??
            TextStyle(backgroundColor: highlightColor),
      ));

      // Update startIndex to the end of the current match
      startIndex = match.end;
    }

    // Add any remaining text after the last match
    if (startIndex < source.length) {
      spans.add(TextSpan(text: source.substring(startIndex)));
    }

    // Return the constructed TextSpan with all the highlighted spans
    return TextSpan(children: spans);
  }
}
