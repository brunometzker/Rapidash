import Vapor

struct LegacyPokemonTypeResponseDTO: Content, Adaptable {
    typealias To = PokemonType
    
    let damage_relations: LegacyPokemonTypeDamageRelations
    let id: Int
    let name: String
    
    func adapt() -> PokemonType {
        let id = self.id
        let name = self.name
        let doubleDamageFrom = self.damage_relations.double_damage_from?.map { $0.name }
        let doubleDamageTo = self.damage_relations.double_damage_to?.map { $0.name }
        let halfDamageFrom = self.damage_relations.half_damage_from?.map { $0.name }
        let halfDamageTo = self.damage_relations.half_damage_to?.map { $0.name }

        let noDamageFrom = self.damage_relations.no_damage_from?.map { $0.name }
        let noDamageTo = self.damage_relations.no_damage_to?.map { $0.name }
        
        return PokemonType(id: id, name: name, doubleDamageFrom: doubleDamageFrom, doubleDamageTo: doubleDamageTo, halfDamageFrom: halfDamageFrom, halfDamageTo: halfDamageTo, noDamageFrom: noDamageFrom, noDamageTo: noDamageTo)
    }
}
