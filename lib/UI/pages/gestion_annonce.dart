// GestionAnnonce.dart
import 'package:allo/data/db/supabase.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/provider/user_provider.dart';
import 'package:allo/service/notif_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GestionAnnonce extends StatefulWidget {
  const GestionAnnonce({Key? key}) : super(key: key);

  @override
  State<GestionAnnonce> createState() => GestionAnnonceState();
}

class GestionAnnonceState extends State<GestionAnnonce> {
  List<Annonce> annonces = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAnnonces();
    });
  }

  fetchAnnonces() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    annonces = await SupabaseDB.selectAnnoncesByUser(userProvider.user["idU"]); 
    setState(() {});
  }

  deleteAnnonce(Annonce annonce) async {
    await SupabaseDB.deleteAnnonce(annonce);
    fetchAnnonces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('les Annonces'),
      ),
      body: ListView.builder(
        itemCount: annonces.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(annonces[index].libelle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white) ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () =>{
                deleteAnnonce(annonces[index]),
                NotificationService().showNotification(
                  title: 'Annonce cloturée',
                  body: 'L\'annonce ${annonces[index].libelle} a été supprimée',
        
                )
              },
              
            ),
          );
        },
      ),
    );
  }
}