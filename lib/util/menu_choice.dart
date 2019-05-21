class MenuChoice {
  final String title;
  final String type;

  const MenuChoice({this.title, this.type});
}

const List<MenuChoice> userMenuChoices = [
  MenuChoice(title: 'Salir', type: 'exit'),
];

const List<MenuChoice> plantDetailMenuChoices = [
  MenuChoice(title: 'Editar', type: 'edit'),
  MenuChoice(title: 'Eliminar', type: 'delete'),
];
