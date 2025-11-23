import 'package:finful_app/app/constants/icons.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/presentation/blocs/signup/signup.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/app_input/FinfulTextInput.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_bar/finful_app_bar.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/common/widgets/my_text_span/my_text_span.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/context_extension.dart';
import 'package:finful_app/core/extension/string_extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'sign_up_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with BaseScreenMixin<SignUpScreen, SignUpRouter> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late TextEditingController _firstnameController;
  final FocusNode _firstnameNode = FocusNode();
  late TextEditingController _lastnameController;
  final FocusNode _lastnameNode = FocusNode();
  late TextEditingController _emailController;
  final FocusNode _emailNode = FocusNode();
  late TextEditingController _passwordController;
  final FocusNode _passwordNode = FocusNode();
  late TextEditingController _passwordConfirmController;
  final FocusNode _passwordConfirmNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscurePasswordConfirm = true;

  @override
  void initState() {
    super.initState();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    _firstnameController.dispose();
    _firstnameNode.dispose();
    _lastnameController.dispose();
    _lastnameNode.dispose();
    _emailController.dispose();
    _emailNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    _passwordConfirmController.dispose();
    _passwordConfirmNode.dispose();
    super.dispose();
  }

  void _handleUnFocus() {
    if (_focusScopeNode.hasFocus) {
      _focusScopeNode.unfocus();
    }
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _togglePasswordConfirm() {
    setState(() {
      _obscurePasswordConfirm = !_obscurePasswordConfirm;
    });
  }

  String? _onFirstnameValidator(String? name) {
    if (name == null) {
      return L10n.of(context).translate('signup_firstname_empty');
    }

    if (name.trim().isEmpty) {
      return L10n.of(context).translate('signup_firstname_empty');
    }

    return null;
  }

  String? _onLastnameValidator(String? lastname) {
    if (lastname == null) {
      return L10n.of(context).translate('signup_lastname_empty');
    }

    if (lastname.trim().isEmpty) {
      return L10n.of(context).translate('signup_lastname_empty');
    }

    return null;
  }

  String? _onEmailValidator(String? email) {
    if (email == null) {
      return L10n.of(context).translate('signup_email_empty');
    }

    if (email.trim().isEmpty) {
      return L10n.of(context).translate('signup_email_empty');
    }

    if (!email.isEmailValid) {
      return L10n.of(context).translate('signup_email_invalid');
    }

    return null;
  }

  String? _onPasswordValidator(String? password) {
    if (password == null) {
      return L10n.of(context).translate('signup_password_empty');
    }

    if (password.trim().isEmpty) {
      return L10n.of(context).translate('signup_password_empty');
    }

    if (!password.trim().isPasswordValid) {
      return L10n.of(context).translate('signup_password_invalid');
    }

    final confirmPassword = _passwordConfirmController.text.trim();
    if (password != confirmPassword) {
      return L10n.of(context).translate('signup_password_not_same');
    }

    return null;
  }

  String? _onPasswordConfirmValidator(String? passwordConfirm) {
    if (passwordConfirm == null) {
      return L10n.of(context).translate('signup_passwordConfirm_empty');
    }

    if (passwordConfirm.trim().isEmpty) {
      return L10n.of(context).translate('signup_passwordConfirm_empty');
    }

    final password = _passwordController.text.trim();
    if (passwordConfirm != password) {
      return L10n.of(context).translate('signup_password_not_same');
    }

    return null;
  }

  void _onSignInPressed() {
    router.gotoSignIn();
  }

  Future<void> _onBackPressed() async {
    _handleUnFocus();
    await Future.delayed(Duration(milliseconds: 300));
    router.pop();
  }

  void _onSubmitPressed() {
    final inputsValid = _formKey.currentState!.validate();
    final passwordStr = _passwordController.text.trim();
    final passwordConfirmStr = _passwordConfirmController.text.trim();
    final passwordSame = passwordStr == passwordConfirmStr;
    if (inputsValid && passwordSame) {
      BlocManager().event<SignUpBloc>(
        BlocConstants.signUp,
        SignUpSubmitted(
          firstName: _firstnameController.text.trim(),
          lastName: _lastnameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        ),
      );
    }
  }

  Future<void> _processAfterSignUpSuccess(SignUpSuccess state) async {
    _handleUnFocus();
    await Future.delayed(Duration(milliseconds: 300));
    router.gotoSignInAuto(
      email: state.email!,
      password: state.password!,
    );
  }

  void _signUpBlocListener(BuildContext context, SignUpState state) {
    if (state is SignUpSuccess) {
      _processAfterSignUpSuccess(state);
    }
  }

  List<BlocListener> get _mapToBlocListeners {
    return [
      BlocListener<SignUpBloc, SignUpState>(
        listener: _signUpBlocListener,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _mapToBlocListeners,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, _) {
          _onBackPressed();
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: FinfulAppBar(
            backgroundColor: Colors.transparent,
            forceMaterialTransparency: true,
            leadingIcon: AppSvgIcon(
              IconConstants.icBack,
              width: FinfulDimens.iconMd,
              height: FinfulDimens.iconMd,
              color: FinfulColor.white,
            ),
            onLeadingPressed: _onBackPressed,
          ),
          body: GestureDetector(
            onTap: _handleUnFocus,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: FinfulDimens.md
              ),
              child: Form(
                key: _formKey,
                child: FocusScope(
                  node: _focusScopeNode,
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: Dimens.p_44,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(
                                  L10n.of(context)
                                      .translate('signup_title'),
                                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                    fontSize: Dimens.p_22,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: FinfulDimens.xs),
                                MyTextSpan(
                                  text: L10n.of(context)
                                      .translate('signup_subtitle'),
                                  defaultStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                                  boldStyle: const TextStyle(
                                    color: FinfulColor.brandPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: Dimens.p_80,
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: FinfulTextInput.single(
                                      controller: _firstnameController,
                                      focusNode: _firstnameNode,
                                      backgroundColor: FinfulColor.textFieldBgColor,
                                      height: FinfulTextInputHeight.md,
                                      hintText: L10n.of(context)
                                          .translate('signup_firstname_hint'),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.go,
                                      prefixIcon: AppSvgIcon(
                                        IconConstants.icGoogle,
                                        width: Dimens.p_20,
                                        height: Dimens.p_20,
                                      ),
                                      validator: _onFirstnameValidator,
                                    ),
                                  ),
                                  SizedBox(width: FinfulDimens.md),
                                  Expanded(
                                    child: FinfulTextInput.single(
                                      controller: _lastnameController,
                                      focusNode: _lastnameNode,
                                      backgroundColor: FinfulColor.textFieldBgColor,
                                      height: FinfulTextInputHeight.md,
                                      hintText: L10n.of(context)
                                          .translate('signup_lastname_hint'),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.go,
                                      prefixIcon: AppSvgIcon(
                                        IconConstants.icGoogle,
                                        width: Dimens.p_20,
                                        height: Dimens.p_20,
                                      ),
                                      validator: _onLastnameValidator,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: FinfulDimens.md),
                              FinfulTextInput.single(
                                controller: _emailController,
                                focusNode: _emailNode,
                                backgroundColor: FinfulColor.textFieldBgColor,
                                height: FinfulTextInputHeight.md,
                                hintText: L10n.of(context)
                                    .translate('signup_email_hint'),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.go,
                                prefixIcon: AppSvgIcon(
                                  IconConstants.icGoogle,
                                  width: Dimens.p_20,
                                  height: Dimens.p_20,
                                ),
                                validator: _onEmailValidator,
                              ),
                              SizedBox(height: FinfulDimens.md),
                              FinfulTextInput.single(
                                controller: _passwordController,
                                focusNode: _passwordNode,
                                height: FinfulTextInputHeight.md,
                                backgroundColor: FinfulColor.textFieldBgColor,
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.go,
                                prefixIcon: AppSvgIcon(
                                  IconConstants.icGoogle,
                                  width: Dimens.p_20,
                                  height: Dimens.p_20,
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    right: Dimens.p_11,
                                  ),
                                  child: InkWell(
                                    onTap: _togglePassword,
                                    child: AppSvgIcon(
                                      IconConstants.icGoogle,
                                      width: Dimens.p_20,
                                      height: Dimens.p_20,
                                    ),
                                  ),
                                ),
                                hintText: L10n.of(context)
                                    .translate('signup_password_hint'),
                                keyboardType: TextInputType.text,
                                validator: _onPasswordValidator,
                              ),
                              SizedBox(height: FinfulDimens.md),
                              FinfulTextInput.single(
                                controller: _passwordConfirmController,
                                focusNode: _passwordConfirmNode,
                                height: FinfulTextInputHeight.md,
                                backgroundColor: FinfulColor.textFieldBgColor,
                                obscureText: _obscurePasswordConfirm,
                                textInputAction: TextInputAction.done,
                                prefixIcon: AppSvgIcon(
                                  IconConstants.icGoogle,
                                  width: Dimens.p_20,
                                  height: Dimens.p_20,
                                ),
                                suffixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    right: Dimens.p_11,
                                  ),
                                  child: InkWell(
                                    onTap: _togglePasswordConfirm,
                                    child: AppSvgIcon(
                                      IconConstants.icGoogle,
                                      width: Dimens.p_20,
                                      height: Dimens.p_20,
                                    ),
                                  ),
                                ),
                                hintText: L10n.of(context)
                                    .translate('signup_passwordConfirm_hint'),
                                keyboardType: TextInputType.text,
                                validator: _onPasswordConfirmValidator,
                              ),
                              const SizedBox(height: Dimens.p_25),
                              FinfulButton.primary(
                                title: L10n.of(context)
                                    .translate('common_cta_signup'),
                                color: FinfulColor.btnAuth,
                                onPressed: _onSubmitPressed,
                              ),
                              const SizedBox(height: Dimens.p_25),
                              SizedBox(
                                width: double.infinity,
                                height: Dimens.p_18,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        height: Dimens.p_1,
                                        decoration: BoxDecoration(
                                            color: FinfulColor.stroke,
                                            border: Border.all(
                                              color: FinfulColor.stroke,
                                              width: Dimens.p_1,
                                              style: BorderStyle.solid,
                                            )
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: FinfulDimens.md
                                      ),
                                      child: Text(
                                        'hoặc',
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: FinfulColor.grey,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        height: Dimens.p_1,
                                        decoration: BoxDecoration(
                                            color: FinfulColor.white,
                                            border: Border.all(
                                              color: FinfulColor.stroke,
                                              width: Dimens.p_1,
                                              style: BorderStyle.solid,
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Dimens.p_25),
                              FinfulButton.border(
                                title: L10n.of(context)
                                    .translate('signin_google_btn'),
                                borderColor: FinfulColor.btnBorderSocial,
                                bgColor: FinfulColor.btnBgSocial,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    right: Dimens.p_10,
                                  ),
                                  child: AppSvgIcon(
                                    IconConstants.icGoogle,
                                    width: Dimens.p_18,
                                    height: Dimens.p_18,
                                  ),
                                ),
                                textStyle: TextStyle(
                                  fontSize: Dimens.p_14,
                                  height: Dimens.p_14 / Dimens.p_14,
                                  fontWeight: FontWeight.w500,
                                  color: FinfulColor.textW,
                                ),
                                onPressed: () {

                                },
                              ),
                              const SizedBox(height: Dimens.p_15),
                              FinfulButton.border(
                                title: L10n.of(context)
                                    .translate('signin_apple_btn'),
                                borderColor: FinfulColor.btnBorderSocial,
                                bgColor: FinfulColor.btnBgSocial,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(
                                    right: Dimens.p_10,
                                  ),
                                  child: AppSvgIcon(
                                    IconConstants.icGoogle,
                                    width: Dimens.p_18,
                                    height: Dimens.p_18,
                                  ),
                                ),
                                textStyle: TextStyle(
                                  fontSize: Dimens.p_14,
                                  height: Dimens.p_14 / Dimens.p_14,
                                  fontWeight: FontWeight.w500,
                                  color: FinfulColor.textW,
                                ),
                                onPressed: () {

                                },
                              ),
                              const SizedBox(height: Dimens.p_44),
                              InkWell(
                                onTap: _onSignInPressed,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimens.p_8
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        L10n.of(context)
                                            .translate('signup_require_signin_title'),
                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          color: FinfulColor.grey2,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: Dimens.p_6),
                                      Text(
                                        L10n.of(context)
                                            .translate('common_cta_signin'),
                                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                          color: FinfulColor.information500,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: Dimens.p_26 + context.queryPaddingBottom),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
