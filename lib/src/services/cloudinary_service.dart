import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:crypto/crypto.dart';

class CloudinaryService{

  Future<Map<String,dynamic>> uploadImage( File image ) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dwhagi5eg/image/upload?upload_preset=brdiw4gx');
    //final url = Uri.parse('https://api.cloudinary.com/v1_1/dc0tufkzf/image/upload?upload_preset=cwye3brj');
    final mimeType = mime(image.path)!.split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest(
        'POST',
        url
    );

    final file = await http.MultipartFile.fromPath(
        'file',
        image.path,
        contentType: MediaType( mimeType[0], mimeType[1] )
    );

    imageUploadRequest.files.add(file);


    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      //print('Algo salio mal');
      //print( resp.body );
      return {'message':resp.body};
    }

    final respData = json.decode(resp.body);
    //print( respData);

    return {"secure_url":respData['secure_url'],"public_id":respData['public_id']};

  }

  Future<String?> deleteImage( String publicId) async {
    var timestamp = DateTime.now().millisecondsSinceEpoch;
    String singleString = "public_id=$publicId&timestamp=${timestamp}wjtVZm823OpjWtnV_wO-_WiyKg0";

    var bytes = utf8.encode(singleString); // data being hashed
    var signature = sha1.convert(bytes); //hex string

    var data = {
      "public_id":publicId,
      "api_key":"765731732897288",
      "signature":signature.toString(),
      "timestamp":timestamp.toString()
    };


    final url = Uri.https('api.cloudinary.com','/v1_1/dwhagi5eg/image/destroy',data);


    final resp = await http.post(
       url,
    );


    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      //print('Algo salio mal');
      //print( resp.body );
      return null;
    }

    final respData = json.decode(resp.body);

    return respData['result'];

  }
}