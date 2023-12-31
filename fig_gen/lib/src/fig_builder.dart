import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_visitor.dart';
import 'package:analyzer/dart/element/visitor.dart';
import 'package:build/build.dart';
import 'package:fig_gen/fig_gen.dart';
import 'package:source_gen/source_gen.dart';


Builder figBuilder(BuilderOptions options) {
  print('Build options = $options');

  return SharedPartBuilder([FigGen(),],'figBuilder');
}

class FigBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    print('Build step:  ${buildStep.resolver}');

  }

  @override
  // TODO: implement buildExtensions
  final buildExtensions = const {
    '.dart': ['.fig.dart']
  };
}
//
// class FigGenerator extends ParserGenerator<FigService> {
//
// }

class ModelVisitor extends SimpleElementVisitor<void> {
  Map<String, dynamic> fields = {};

  @override
  void visitFieldElement(FieldElement element) {
    print('visited $element');
    /*
    {
      name: String,
      price: double
    }
     */



// Step 6
    String elementType = element.type.toString().replaceAll("*", "");
    fields[element.name] = elementType;
  }

  @override
  visitMethodElement(element) {
    print('visted method $element');
  }

}

class _BaseClassVisitor implements TypeVisitor {

  StringBuffer output = StringBuffer();

  @override
  visitDynamicType(DynamicType type) {
    // TODO: implement visitDynamicType
    print('dynamic visit');
    throw UnimplementedError();
  }

  @override
  visitFunctionType(FunctionType type) {
    // TODO: implement visitFunctionType
    print('function visit');
    throw UnimplementedError();
  }

  @override
  visitInterfaceType(InterfaceType type) {
    print('visit interface $type');

    for( var m in type.methods) {
      if( m.isAbstract) {
        output.writeln('// $m');
      }
    }
  }

  @override
  visitInvalidType(InvalidType type) {
    // TODO: implement visitInvalidType
    throw UnimplementedError();
  }

  @override
  visitNeverType(NeverType type) {
    // TODO: implement visitNeverType
    throw UnimplementedError();
  }

  @override
  visitRecordType(RecordType type) {
    // TODO: implement visitRecordType
    throw UnimplementedError();
  }

  @override
  visitTypeParameterType(TypeParameterType type) {
    // TODO: implement visitTypeParameterType
    throw UnimplementedError();
  }

  @override
  visitVoidType(VoidType type) {
    // TODO: implement visitVoidType
    throw UnimplementedError();
  }


}
class FigGen extends GeneratorForAnnotation<FigService> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element, // Represent a class in this case.
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {

    var c = annotation.read('grpcClass');
    print('c = $c  type = ${c.typeValue}');
    var t = c.typeValue;

    final tVis = _BaseClassVisitor();

    try {
      t.accept(tVis);
    }
    catch(e,s) {
      print(e);
      print(s);
    }

    final visitor = ModelVisitor();

    print('FigGen: $element');

    element.visitChildren(visitor);


    return tVis.output.toString();
  }
}
