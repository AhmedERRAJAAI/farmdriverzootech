import 'package:farmdriverzootech/farmdriver_base/provider/auth_provider.dart';
import 'package:farmdriverzootech/farmdriver_base/widgets/info_dialog.dart';
import 'package:farmdriverzootech/production/analyses/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfScreen extends StatefulWidget {
  final String pdfUrl;
  final String name;
  const ViewPdfScreen({
    super.key,
    required this.pdfUrl,
    required this.name,
  });

  @override
  State<ViewPdfScreen> createState() => _ViewPdfScreenState();
}

class _ViewPdfScreenState extends State<ViewPdfScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool isLoading = false;
  bool downloading = false;
  bool failedToFetch = false;

  void downloadReport(context) async {
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<AnalysesProvider>(context, listen: false).shareDownloadedPdf(widget.pdfUrl).then((_) {
        setState(() {
          isLoading = false;
          failedToFetch = false;
        });
      });
    } catch (e) {
      int? statusCode = int.tryParse(e.toString().replaceAll('Exception:', '').trim());
      if (statusCode == 401) {
        try {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.tryAutoLogin().then((_) {
            downloadReport(context);
          });
        } catch (e) {
          Navigator.of(context).pushNamed("auth-screen/");
        }
      } else {
        AlertsDialog.doUreallyWant(
          context,
          "Echec",
          "échec de récupération des données",
          "Réessayer",
          true,
          downloadReport,
        );
      }
      setState(() {
        isLoading = false;
        failedToFetch = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                downloadReport(context);
              },
              icon: const Icon(Icons.ios_share))
        ],
      ),
      body: SfPdfViewer.network(
        widget.pdfUrl,
        key: _pdfViewerKey,
      ),
    );
  }
}
