import 'package:auto_size_text/auto_size_text.dart';
import 'package:ext_library/lib_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';

import '../tool/log_manager.dart';

class NetworkLogMainPage extends StatefulWidget {
  const NetworkLogMainPage({Key? key}) : super(key: key);

  @override
  _NetworkLogMainPageState createState() => _NetworkLogMainPageState();
}

class _NetworkLogMainPageState extends State<NetworkLogMainPage> {
  DebugLogSer get store => DebugLogSer.to;
  late final ReactionDisposer _disposer;

  bool hasFilter = false;

  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    store.logFilter();
    _textController = TextEditingController();
    _disposer = autorun((_) {
      store.listLog;
    });
  }

  @override
  void dispose() {
    _disposer.call();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildBody().fill(),
        buildAction().positioned(top: 22, right: 12)
      ],
    );
  }

  Widget buildBody() {
    return Obx(() {
      final displayList = store.filterLog;
      return Column(
        children: [
          _buildInput().visible(hasFilter),
          displayList.empty
              ? const Center(
                  child: Text(
                    '暂无数据',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                )
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (_, int index) {
                    return ListItem(
                      index: index,
                      logData: displayList[index],
                    );
                  },
                  separatorBuilder: (_, int index) {
                    return Container();
                  },
                  itemCount: displayList.length,
                ).expanded()
        ],
      );
    });
  }

  Widget buildAction() {
    return Column(
      children: [
        Container(
          height: 32,
          width: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: const Icon(
            Icons.cleaning_services_outlined,
            color: Colors.white,
            size: 14,
          ),
        ).onClick(onTap: () => store.clearLog()),
        Container(
          height: 32,
          width: 32,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: const Icon(
            Icons.search_sharp,
            color: Colors.white,
            size: 14,
          ),
        ).onClick(onTap: () {
          hasFilter = !hasFilter;
          if (!hasFilter) {
            store.logFilter();
          }
          setState(() {});
        })
      ].div(10.hGap),
    );
  }

  Widget _buildInput() {
    return Container(
      height: 44,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 33,
              alignment: Alignment.centerLeft,
              child: CupertinoTextField(
                controller: _textController,
                style: TextStyle(fontSize: 12, color: Colors.black),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: 10.borderAll,
                ),
                padding: 10.all,
                onSubmitted: (_) => store.logFilter(text: _),
              ),
            ),
          ),
          10.wGap,
          SizedBox(
            width: 58,
            height: 33,
            child: TextButton(
              onPressed: () => store.logFilter(text: _textController.text),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
              ),
              child: const Text('Search', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    ).clipRRect(all: 10).pOnly(left: 20, right: 80);
  }
}

class ListItem extends StatefulWidget {
  const ListItem({
    Key? key,
    required this.index,
    required this.logData,
  }) : super(key: key);

  final int index;
  final LogData logData;

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool isExpand = false;
  LogData get data => widget.logData;
  int get postion => widget.index + 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isExpand ? Border.all(color: Colors.green) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              isExpand = !isExpand;
              setState(() {});
            },
            child: _buildTitle(),
          ),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final MaterialColor statusColor =
        data.isSuccess ? Colors.green : Colors.red;
    // final methodColor = data.method.toLower == 'get'
    //     ? Colors.white
    //     : data.method.toLower == 'post'
    //         ? Colors.orange
    //         : Colors.white;
    Color methodColor = Colors.white;
    switch (data.method.toLower) {
      case 'get':
        methodColor = Colors.white;
        break;
      case 'post':
        methodColor = Colors.black;
        break;
      case 'put':
        methodColor = Colors.purple;
        break;
      case 'delete':
        methodColor = Colors.red;
        break;
      default:
    }
    final Padding title = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '路径$postion:',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 12, color: statusColor),
              ),
              const SizedBox(width: 5),
              Container(
                padding: 2.all.copyWith(left: 4, right: 4),
                color: data.isSuccess ? Colors.greenAccent : Colors.redAccent,
                child: Text(
                  data.method.toUpper,
                  style: TextStyle(
                      fontSize: 7,
                      color: methodColor,
                      fontWeight: FontWeight.bold),
                ),
              ).clipRRect(all: 4),
              const SizedBox(width: 5),
              Expanded(
                child: AutoSizeText(
                  data.path.fixLines,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 12, color: statusColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          4.hGap,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '状态  :',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12,
                      color: statusColor,
                    ),
              ),
              const SizedBox(width: 3),
              SizedBox(
                width: 10,
                height: 10,
                child: Icon(
                  data.isSuccess
                      ? Icons.check_circle_outline
                      : Icons.close_outlined,
                  color: statusColor,
                  size: 10,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                'time: ${data.duration?.msec}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 10, color: statusColor),
              ),
              3.wGap,
              Container(
                margin: 3.left,
                padding: 2.all,
                decoration: BoxDecoration(
                    borderRadius: 4.borderAll,
                    border: Border.all(color: Colors.grey.shade300, width: .5)),
                child: Text(
                  data.respText.safety.length.bytesFormat,
                  style: TextStyle(
                      fontSize: 8,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     color: Colors.grey,
              //     borderRadius: 4.borderAll,
              //   ),
              //   margin: 10.left,
              //   padding: 2.vertical,
              //   child: Text(
              //     ' 灰度: {beta:${data.header['beta']}} ',
              //     style: Theme.of(context)
              //         .textTheme
              //         .headlineSmall
              //         ?.copyWith(fontSize: 10, color: Colors.white),
              //   ),
              // ).visible(data.header.containsKey('beta')),

              Text(
                'start: ${data.time?.hmsDotSS}',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontSize: 9, color: statusColor),
                textAlign: TextAlign.end,
                maxLines: 1,
              ).expanded(),
            ],
          ),
        ],
      ),
    );
    final Icon rightArrow = Icon(
      isExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
      size: 20,
      color: statusColor,
    );

    return Row(
      children: [
        Expanded(child: title),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: rightArrow,
        )
      ],
    );
  }

  Widget _buildBody() {
    if (!isExpand) {
      return const Divider(height: 0.5, thickness: 0.5);
    }
    return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildInfoItem(
            title: 'Url:',
            content: data.url,
            copyEnable: true,
          ),
          // _buildInfoItem(title: '请求方式:', content: data.method),
          _buildInfoItem(
            title: '请求参数:',
            content: data.params,
            copyEnable: true,
          ),
          _buildInfoItem(
              title: 'Header:',
              content: data.header.jsonFormat,
              copyEnable: true),
          _buildInfoItem(title: '类型:', content: data.respType),
          if (!data.respCode.isnull)
            _buildInfoItem(title: 'Http状态码:', content: data.respCode!),
          if (!data.respMsg.isnull)
            _buildInfoItem(title: 'Http信息:', content: '${data.respMsg}'),
          if (data.respText != null)
            _buildInfoItem(
              title: '结果:',
              content: data.respText.safety,
              copyEnable: true,
            ),
          _buildErrorInfo(),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String title,
    required String content,
    bool copyEnable = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                ),
                Visibility(
                  visible: copyEnable,
                  child: InkWell(
                    onTap: () {
                      libTools.copy(content.replaceAll('\u{200B}', ''));
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.all(5.0),
                      child:
                          const Icon(Icons.copy, size: 8, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(fontSize: 10, color: Colors.black),
            ),
            // child: ExpandableText(
            //   text: content.safety,
            //   textStyle: const TextStyle(color: Colors.black, fontSize: 10),
            //   buttonTextStyle:
            //       const TextStyle(fontSize: 10, color: Colors.orange),
            //   initLength: 300,
            //   textAlign: TextAlign.start,
            //   expanded: (v) => setState(() {}),
            // ),
            // child: SelectableText.rich(
            //   TextSpan(
            //     text: '',
            //     children: [
            //       WidgetSpan(
            //         child: ExpandableText(
            //           text: content.safety,
            //           textStyle:
            //               const TextStyle(color: Colors.black, fontSize: 10),
            //           buttonTextStyle:
            //               const TextStyle(fontSize: 10, color: Colors.orange),
            //           // initLength: 300,
            //           expanded: (v) => setState(() {}),
            //         ),
            //       ),
            //     ],
            //   ),
            //   style: const TextStyle(color: Colors.black, fontSize: 10),
            // ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorInfo() {
    if (data.isSuccess) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildInfoItem(title: '错误类型', content: data.errorType.toString()),
        _buildInfoItem(title: '错误信息', content: data.errorMessage.toString()),
        _buildInfoItem(title: '错误对象', content: data.error.toString()),
      ],
    );
  }
}
