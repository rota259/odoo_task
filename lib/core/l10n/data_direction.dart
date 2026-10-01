import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' as intl;

/// Direction for user/server data (addresses, product names...): follows
/// the text's own script instead of the UI locale, so Latin data is not
/// reordered inside Arabic layouts.
TextDirection dataDirection(String text) =>
    intl.Bidi.detectRtlDirectionality(text)
    ? TextDirection.rtl
    : TextDirection.ltr;
