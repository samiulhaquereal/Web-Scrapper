import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'model.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({super.key});

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}



class _ListViewPageState extends State<ListViewPage> {
  List<Artical> artical =[];


  Future getwebsiteData() async {
    final url = Uri.parse('https://www.imdb.com/chart/top/?ref_=nv_mv_250');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);
    print(html);

    final titles = html
        .querySelectorAll('div.ipc-title.ipc-title--base.ipc-title--title.ipc-title-link-no-icon.ipc-title--on-textPrimary.sc-c7e5f54-9.irGIRq.cli-title > a > h3')
        .map((element) => element.innerHtml.trim())
        .toList();

    /*final urls = html
        .querySelectorAll('div.ipc-title.ipc-title--base.ipc-title--title.ipc-title-link-no-icon.ipc-title--on-textPrimary.sc-c7e5f54-9.irGIRq.cli-title > a')
        .map((element) => element.attributes['href'])
        .toList();*/
    final urls = html
        .querySelectorAll('div.sc-c7e5f54-7.brlapf.cli-title-metadata > span:nth-child(1)')
        .map((element) => element.innerHtml.trim())
        .toList();

    final pic = html
        .querySelectorAll('div > div.ipc-media.ipc-media--poster-27x40.ipc-image-media-ratio--poster-27x40.ipc-media--base.ipc-media--poster-m.ipc-poster__poster-image.ipc-media__img > img')
        .map((element) => element.attributes['src'])
        .toList();

    print('Count: ${titles.length}');
    print('Count: ${urls.length}');
    print('Count: ${pic.length}');

    /*for (final title1 in titles) {
      debugPrint(title1);
    }
    for (final title in urls) {
      debugPrint(title);
    }*/
    /*for (final title in pic) {
      debugPrint(title);
    }*/

    setState(() {
      artical = List.generate(titles.length, (index) =>
          Artical(
            title: titles[index],
            url: urls[index]!,
            urlImage: pic[index]!,)
      );
    });
  }

  @override
  void initState() {
    super.initState();
    this.getwebsiteData();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(backgroundColor: Colors.yellow,title: Text('IMDb',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),)),
      body: Container(
        child: ListView.builder(
            itemCount: artical.length,
            itemBuilder: (context,index){
              final articals = artical[index];
          return ListTile(
            title: Text(articals.title),
            subtitle: Text(articals.url),
            leading: Image.network(articals.urlImage),
          );
        }),
      ),
    ));
  }
}
