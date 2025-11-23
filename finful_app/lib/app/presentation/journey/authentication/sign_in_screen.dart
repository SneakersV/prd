import 'package:finful_app/app/constants/constants.dart';
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/presentation/blocs/create_plan/create_plan.dart';
import 'package:finful_app/app/presentation/blocs/mixins/loader_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/mixins/stored_draft_bloc_mixin.dart';
import 'package:finful_app/app/presentation/blocs/signin/signin.dart';
import 'package:finful_app/app/presentation/blocs/stored_draft/stored_draft.dart';
import 'package:finful_app/app/presentation/journey/authentication/sign_in_router.dart';
import 'package:finful_app/app/presentation/widgets/app_button/FinfulButton.dart';
import 'package:finful_app/app/presentation/widgets/app_input/FinfulTextInput.dart';
import 'package:finful_app/app/theme/colors.dart';
import 'package:finful_app/app/theme/dimens.dart';
import 'package:finful_app/common/constants/dimensions.dart';
import 'package:finful_app/common/widgets/app_bar/finful_app_bar.dart';
import 'package:finful_app/common/widgets/app_icon/app_icon.dart';
import 'package:finful_app/common/widgets/my_text_span/my_text_span.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';
import 'package:finful_app/core/extension/extension.dart';
import 'package:finful_app/core/localization/l10n.dart';
import 'package:finful_app/core/presentation/base_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with BaseScreenMixin<SignInScreen, SignInRouter>,
        StoredDraftBlocMixin, LoaderBlocMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late TextEditingController _emailController;
  final FocusNode _emailNode = FocusNode();
  late TextEditingController _passwordController;
  final FocusNode _passwordNode = FocusNode();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void didMountWidget() {
    super.didMountWidget();
    _processAutoSubmitLogin();
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    _emailController.dispose();
    _emailNode.dispose();
    _passwordController.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  void _handleUnFocus() {
    if (_focusScopeNode.hasFocus) {
      _focusScopeNode.unfocus();
    }
  }

  String? _onEmailPasswordValidator(String? password) {
    if (_emailController.text.trim().isNullOrEmpty) {
      return L10n.of(context).translate('signin_email_empty');
    }

    if (password.isNullOrEmpty) {
      return L10n.of(context).translate('signin_password_empty');
    }

    return null;
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _processAutoSubmitLogin() {
    if (isAutoLogin) {
      showAppLoading();
      _emailController.text = router.email!;
      _passwordController.text = router.password!;
      _onSubmitPressed();
    }
  }

  void _onSubmitPressed() {
    final inputsValid = _formKey.currentState!.validate();
    if (inputsValid) {
      BlocManager().event<SignInBloc>(
        BlocConstants.signIn,
        SignInSubmitted(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim()
        ),
      );
    }
  }

  // co nghia la di tu luong sau khi sign up success -> signin (screen nay)
  bool get isAutoLogin {
    return router.email.isNotNullAndEmpty &&
        router.password.isNotNullAndEmpty;
  }

  Future<void> _onBackPressed() async {
    _handleUnFocus();
    await Future.delayed(Duration(milliseconds: 300));
    router.pop();
  }

  void _gotoDashboard() {
    router.gotoDashboard();
  }

  void _gotoSignUpPressed() {
    if (router.entryFrom == SignInEntryFrom.signUp) {
      router.pop();
    } else if (router.entryFrom == SignInEntryFrom.other) {
      router.gotoSignUp();
    }
  }

  Future<void> _processAfterSignInSuccess() async {
    _handleUnFocus();
    await Future.delayed(Duration(milliseconds: 300));
    final onboardingDraftData = getStoredDraftState.onboardingAnswersDraft;
    final isHasData = onboardingDraftData != null && onboardingDraftData.isNotEmpty;
    final shouldCreatePlan = isAutoLogin && isHasData;
    if (shouldCreatePlan) {
      BlocManager().event<CreatePlanBloc>(
        BlocConstants.createPlan,
        CreatePlanFromDraftDataStarted(
          answersFilled: onboardingDraftData,
        ),
      );
    } else {
      _gotoDashboard();
    }
  }

  void _processAfterStartedCreatePlanFromDraftData() {
    BlocManager().event<StoredDraftBloc>(
      BlocConstants.storedDraft,
      StoredDraftClearOnboardingDataStarted(),
    );
    _gotoDashboard();
  }

  void _signInBlocListener(BuildContext context, SignInState state) {
    if (state is SignInSuccess) {
      _processAfterSignInSuccess();
    }
  }

  void _createPlanBlocListener(BuildContext context, CreatePlanState state) {
    if (state is CreatePlanFromDraftDataSuccess ||
      state is CreatePlanFromDraftDataFailure) {
      _processAfterStartedCreatePlanFromDraftData();
    }
  }

  List<BlocListener> get _mapToBlocListeners {
    return [
      BlocListener<SignInBloc, SignInState>(
        listener: _signInBlocListener,
      ),
      BlocListener<CreatePlanBloc, CreatePlanState>(
        listener: _createPlanBlocListener,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: _mapToBlocListeners,
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
                                    .translate('signin_title'),
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: Dimens.p_22,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: FinfulDimens.xs),
                              MyTextSpan(
                                text: L10n.of(context)
                                    .translate('signin_subtitle'),
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
                            FinfulTextInput.single(
                              controller: _emailController,
                              focusNode: _emailNode,
                              backgroundColor: FinfulColor.textFieldBgColor,
                              height: FinfulTextInputHeight.md,
                              hintText: L10n.of(context)
                                  .translate('signin_email_hint'),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.go,
                              prefixIcon: AppSvgIcon(
                                IconConstants.icGoogle,
                                width: Dimens.p_20,
                                height: Dimens.p_20,
                              ),
                            ),
                            SizedBox(height: FinfulDimens.md),
                            FinfulTextInput.single(
                              controller: _passwordController,
                              focusNode: _passwordNode,
                              height: FinfulTextInputHeight.md,
                              backgroundColor: FinfulColor.textFieldBgColor,
                              obscureText: _obscurePassword,
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
                                  onTap: _togglePassword,
                                  child: AppSvgIcon(
                                    IconConstants.icGoogle,
                                    width: Dimens.p_20,
                                    height: Dimens.p_20,
                                  ),
                                ),
                              ),
                              hintText: L10n.of(context)
                                  .translate('signin_password_hint'),
                              keyboardType: TextInputType.text,
                              validator: _onEmailPasswordValidator,
                            ),
                            const SizedBox(height: Dimens.p_12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Container()),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {

                                    },
                                    child: Text(
                                      L10n.of(context)
                                          .translate('signin_forgot_password_btn'),
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: FinfulColor.information500,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimens.p_25),
                            FinfulButton.primary(
                              title: L10n.of(context)
                                  .translate('common_cta_signin'),
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
                            const SizedBox(height: Dimens.p_104),
                            InkWell(
                              onTap: _gotoSignUpPressed,
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
                                          .translate('signin_require_signup_title'),
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                        color: FinfulColor.grey2,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: Dimens.p_6),
                                    Text(
                                      L10n.of(context)
                                          .translate('common_cta_signup'),
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
    );
  }
}
