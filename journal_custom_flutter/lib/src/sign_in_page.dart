import 'package:flutter/material.dart';
import 'package:serverpod_auth_email_flutter/serverpod_auth_email_flutter.dart';
import 'package:journal_custom_flutter/src/serverpod_client.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SignInWithEmailDialogLabels loc = SignInWithEmailDialogLabels(
      inputHintUserName: 'Имя пользователя', 
      inputHintEmail: 'Email', 
      inputHintPassword: 'Пароль',
      buttonTitleSignUp: 'Зарегистрироваться', 
      buttonTitleOpenSignUp: 'Регистрация', 
      buttonTitleOpenSignIn: 'Открыть вход', 
      buttonTitleSignIn: 'Войти', 
      buttonTitleForgotPassword: 'Забыл?', 
      buttonTitleResetPassword: 'Сбросить пароль', 
      inputHintNewPassword: 'Новый пароль', 
      buttonTitleBack: 'Назад', 
      messageEmailVerificationSent: 'Письмо с подтверждением отправлено на ваш email.', 
      inputHintValidationCode: 'Код подтверждения', 
      messagePasswordResetSent: 'Письмо с инструкциями по сбросу пароля отправлено на ваш email.', 
      errorMessageUserNameRequired: 'Имя пользователя обязательно', 
      errorMessageInvalidEmail: 'Некорректный email', 
      minimumLengthMessage: (int length) { 
        return 'Минимальная длина пароля: $length символов';
      }, 
      maximumLengthMessage: (int length) { 
        return 'Максимальная длина пароля: $length символов';
      }, 
      errorMessageEmailInUse: 'Email уже используется', 
      messageEnterCode: 'Введите код подтверждения, отправленный на ваш email', 
      errorMessageIncorrectCode: 'Некорректный код подтверждения', 
      errorMessageIncorrectPassword: 'Некорректный пароль',
    );
    return Center(
      child: Dialog(
        child: Container(
          color: Theme.of(context).colorScheme.surface, // Используем цвет темы для фона
          width: 400, // Увеличил ширину для лучшего отображения
          padding: const EdgeInsets.all(24), // Немного увеличил отступы
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0), // Отступ снизу для логотипа
                child: Image.asset(
                  'assets/images/sibadi_logo.png', // Убедитесь, что путь и имя файла верны
                  height: 150, // Немного уменьшил высоту логотипа для баланса
                  // width: 150, // Можете настроить ширину, если нужно
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Журнал посещаемости',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall, // Используем стиль заголовка
                ),
              ),
              SignInWithEmailButton(
                caller: client.modules.auth,
                label: const Text('Войти с Email'), // Используем const для Text
                localization: loc,
              ),
            ],
          ),
        ),
      ),
    );
  }
}