import 'package:get_cli/commands/impl/create/create.dart';
import 'package:get_cli/commands/interface/command.dart';
import 'package:get_cli/core/structure.dart';
import 'package:get_cli/functions/create/create_single_file.dart';
import 'package:get_cli/functions/exports_files/add_export.dart';
import 'package:get_cli/functions/routes/arc_add_route.dart';
import 'package:get_cli/get_cli.dart';
import 'package:get_cli/models/file_model.dart';
import 'package:get_cli/samples/impl/get_binding.dart';
import 'package:get_cli/samples/impl/arc_screen.dart';
import 'package:get_cli/samples/impl/get_controller.dart';
import 'package:recase/recase.dart';

class CreateScreenCommand extends Command with CreateMixin {
  @override
  Future<void> execute() async {
    bool isExample = GetCli.arguments.first == 'init';

    FileModel _fileModel = Structure.model(name, 'screen', true);

    ReCase reCase = ReCase(_fileModel.name);

    await writeFile(_fileModel.path + '.screen.dart',
        ArcScreenSample().file(name, isExample: isExample));

    await addExport('lib/presentation/screens.dart',
        '''export '${reCase.snakeCase}/${reCase.snakeCase}.screen.dart';''');

    await writeFile(
        'lib/infrastructure/navigation/bindings/controllers/${reCase.snakeCase}.controller.binding.dart',
        BindingSample().file(name, isArc: true));

    await addExport(
        'lib/infrastructure/navigation/bindings/controllers/controllers_bindings.dart',
        '''export '${reCase.snakeCase}.controller.binding.dart';''');

    await writeFile(
        'lib/presentation/${reCase.snakeCase}/controllers/${reCase.snakeCase}.controller.dart',
        ControllerSample().file(name, isArc: !isExample));

    await arcAddRoute(name);
  }

  @override
  String get hint => 'Generate new screen';

  @override
  bool validate() {
    throw true;
  }
}
