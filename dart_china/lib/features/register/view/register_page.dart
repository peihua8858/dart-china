import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../../common.dart';
import '../../../widgets/button_widget.dart';
import '../../../widgets/widgets.dart';
import '../bloc/register_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();

    form = FormGroup({
      'email': FormControl<String>(validators: [
        Validators.required,
        Validators.email,
      ], asyncValidators: [
        CheckAsyncValidator(context, 'email'),
      ]),
      'username': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(3),
          Validators.pattern(RegExps.username, validationMessage: '只能包含字母和数字')
        ],
        asyncValidators: [CheckAsyncValidator(context, 'username')],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(10)],
      ),
      'passwordConfirm': FormControl<String>(validators: [
        Validators.required,
      ]),
    }, validators: [
      CheckMustMatchValidator(),
    ]);
  }

  ValidatorFunction _checkMustMatch(
      {String name = 'password', String confirmName = 'passwordConfirm'}) {
    return (AbstractControl<dynamic> control) {
      final form = control as FormGroup;

      final formControl = form.control(name);
      final matchingFormControl = form.control(confirmName);

      if (formControl.value != matchingFormControl.value) {
        matchingFormControl.setErrors({'mustMatch': true});
      } else {
        matchingFormControl.removeError('mustMatch');
      }

      return null;
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: BlocConsumer<RegisterBloc, RegisterState>(
            listener: (context, state) {
              if (state is RegisterPending) {
                FocusManager.instance.primaryFocus?.unfocus();
                EasyLoading.show();
              } else if (state is RegisterSuccess) {
                FocusManager.instance.primaryFocus?.unfocus();
                EasyLoading.showToast(Messages.registerSuccess);
                Navigator.of(context)
                    .popUntil(ModalRoute.withName(Routes.home));
              } else if (state is RegisterFailure) {
                FocusManager.instance.primaryFocus?.unfocus();
                EasyLoading.showToast(Messages.registerFail);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  _buildHead(),
                  _buildForm(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHead() {
    return Container(
      color: ColorPalette.backgroundColor,
      width: double.infinity,
      padding: EdgeInsets.only(top: 60, bottom: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28,
            child: Image.asset(
              'assets/icon/logo_dart.png',
              height: 40,
              width: 40,
            ),
          ),
          SizedBox(height: 20),
          Text(
            '欢迎注册 Dart China',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: ReactiveForm(
        formGroup: form,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            ReactiveInputWidget(
              autofocus: false,
              email: true,
              name: 'email',
              label: '邮箱',
              hint: '绝不会被公开展示',
              messages: Map.from({
                'required': '邮箱不能为空',
                'email': '请正确填写邮箱',
                'available': '邮箱不可用',
              }),
              inputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 15,
            ),
            ReactiveInputWidget(
              name: 'username',
              label: '用户名',
              hint: '独一无二，只包含数字和字母',
              messages: Map.from({
                'required': '用户名不能为空',
                'minLength': '最小长度为3',
                'available': '用户名不可用',
                'pattern': '用户名只能包含数字和字母'
              }),
              inputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 15,
            ),
            ReactiveInputWidget(
              name: 'password',
              label: '密码',
              hint: '至少10位，非简单密码',
              messages: Map.from({
                'required': '密码不能为空',
                'minLength': '最小长度为10',
              }),
              obscure: true,
              inputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 15,
            ),
            ReactiveInputWidget(
              name: 'passwordConfirm',
              label: '密码确认',
              hint: '请重复输入一次密码',
              messages: Map.from({
                'required': '密码确认不能为空',
                'mustMatch': '密码与确认不一致',
              }),
              obscure: true,
              inputAction: TextInputAction.done,
            ),
            SizedBox(height: 45),
            ButtonWidget(
              text: '注册',
              onPressed: () {
                form.markAllAsTouched();
                if (form.valid) {
                  var email = form.control('email').value;
                  var username = form.control('username').value;
                  var password = form.control('password').value;
                  context.read<RegisterBloc>().add(RegisterPost(
                      email: email, username: username, password: password));
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            TosPrivacy(),
          ],
        ),
      ),
    );
  }
}

class CheckMustMatchValidator extends Validator<dynamic> {
  final String name = 'password';
  final String confirmName = 'passwordConfirm';

  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    final form = control as FormGroup;

    final formControl = form.control(name);
    final matchingFormControl = form.control(confirmName);

    if (formControl.value != matchingFormControl.value) {
      matchingFormControl.setErrors({'mustMatch': true});
    } else {
      matchingFormControl.removeError('mustMatch');
    }
    return null;
  }
}

class CheckAsyncValidator extends AsyncValidator<dynamic> {
  final BuildContext context;
  final String name;

  const CheckAsyncValidator(this.context, this.name) : super();

  @override
  Future<Map<String, dynamic>?> validate(
      AbstractControl<dynamic> control) async {
    final error = {'available': false};
    switch (name) {
      case 'username':
        final available = await context
            .read<RegisterBloc>()
            .checkAvailable(username: control.value);
        return available ? {} : error;
      case 'email':
        final available = await context
            .read<RegisterBloc>()
            .checkAvailable(email: control.value);
        return available ? {} : error;
    }
    return {};
  }
}