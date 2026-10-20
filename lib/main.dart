import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_ma/data/repositories/student_repository.dart';
import 'package:school_ma/data/repositories/subject_repository.dart';
import 'package:school_ma/data/services/subject_service.dart';
import 'package:school_ma/screens/auth/login_screen.dart';
import 'package:school_ma/screens/home/home_screen.dart';
import 'package:school_ma/viewmodels/class/class_cubit.dart';
import 'package:school_ma/viewmodels/grade/grade_cubit.dart';
import 'package:school_ma/viewmodels/major/major_cubit.dart';
import 'package:school_ma/viewmodels/session/session_cubit.dart';
import 'package:school_ma/viewmodels/session/tuition_rate_cubit.dart';
import 'package:school_ma/viewmodels/student/student_cubit.dart';
import 'package:school_ma/data/repositories/tuition_rate_repository.dart';
import 'package:school_ma/data/services/tuition_rate_api_service.dart';
import 'package:school_ma/viewmodels/session/tuition_rate_cubit.dart';
import 'package:school_ma/viewmodels/subject/subject_cubit.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/class_repository.dart';
import 'data/repositories/grade_repository.dart';
import 'data/repositories/major_repository.dart';
import 'data/repositories/session_repository.dart';
import 'data/services/auth_api_service.dart';
import 'data/services/class_service.dart';
import 'data/services/grade_service.dart';
import 'data/services/major_service.dart';
import 'data/services/session_service.dart';
import 'viewmodels/auth/auth_cubit.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // =========================
        // AUTH
        // =========================

        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            authRepository: AuthRepository(
              authApiService: AuthApiService(),
            ),
          ),
        ),

        BlocProvider(
          create: (_) => StudentCubit(
            repository: StudentRepository(),
          ),
        ),

        // Grade
        BlocProvider(
          create: (_) => GradeCubit(
            repository: GradeRepository(
              service: GradeService(),
            ),
          ),
        ),
        //class
        BlocProvider(
          create: (_) => ClassCubit(
            repository: ClassRepository(
              service: ClassService(),
            ),
          ),
        ),
        //session
        BlocProvider(
          create: (_) => SessionCubit(
            repository: SessionRepository(
              service: SessionService(),
            ),
          ),
        ),
        // TUITION RATE
        BlocProvider<TuitionRateCubit>(
          create: (_) => TuitionRateCubit(
            TuitionRateRepository(
              TuitionRateApiService(),
            ),
          ),
        ),
        BlocProvider<MajorCubit>(
          create: (_) => MajorCubit(
            repository: MajorRepository(
              service: MajorService(),
            ),
          ),
        ),
        // SUBJECT
        BlocProvider<SubjectCubit>(
          create: (_) => SubjectCubit(
            SubjectRepository(
              SubjectService(),
            ),
          )..loadSubjects(),
        ),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'School Project',
        home: const LoginScreen(),
      ),
    );
  }
}