import 'package:daily_discipleship/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class HymnPdfViewer extends StatelessWidget {
  final String storagePath;
  const HymnPdfViewer({super.key, required this.storagePath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: StorageService().getDownloadURL(storagePath),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Directly use the URL to load the PDF
          return Expanded(
            child: SfPdfViewer.network(
              snapshot.data!,
              canShowScrollHead: true,
              canShowScrollStatus: true,
              enableDoubleTapZooming: true,
              enableTextSelection: false,
              onDocumentLoaded: (details) {
                if (context.mounted) {
                  var snackBar = SnackBar(
                      content: const Center(
                          child: Text(
                              'Tip: Use your fingers to pan and pinch to zoom in/out on the PDF.')),
                      duration: const Duration(milliseconds: 3000),
                      width: 280.0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          );
        }
      },
    );
  }
}
