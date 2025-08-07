import 'dart:convert';

Superviseur superviseurFromJson(String str) => Superviseur.fromJson(json.decode(str));

String superviseurToJson(Superviseur data) => json.encode(data.toJson());

class Superviseur {
	int id;
	String nom;
	String nom_utilisateur;
	String lot;
	String? psswd;
	Superviseur({
	required this.nom_utilisateur,
	required this.id,
	required this.lot,
	required this.nom
	});
	void setPassword(String pssw) {
		psswd = pssw;
	}
    factory Superviseur.fromJson(Map<String, dynamic> json) => Superviseur(
        id: json["id"],
        lot: json["lot"],
        nom: json["nom"],
        nom_utilisateur: json["_n_9032"]
    );

    Map<String, dynamic> toJson() => {
        "_n_9032": nom_utilisateur,
        "lot": lot,
        "nom": nom,
    };
}
