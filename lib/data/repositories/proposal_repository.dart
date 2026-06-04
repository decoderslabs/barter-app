import '../../core/network/barter_api_client.dart';
import '../dto/paginated_response.dart';
import '../dto/proposal_dto.dart';

class ProposalRepository {
  ProposalRepository({BarterApiClient? client}) : _client = client ?? BarterApiClient();

  final BarterApiClient _client;

  Future<List<ProposalListItemDto>> listProposals() async {
    final data = await _client.getJson('/proposals');
    return PaginatedResponse.fromJson(data, ProposalListItemDto.fromJson).results;
  }

  Future<ProposalDetailDto> getProposal(String id) async {
    final data = await _client.getJson('/proposals/$id');
    return ProposalDetailDto.fromJson(data);
  }

  Future<void> createProposal({
    required String offerId,
    required String pitch,
    required Map<String, dynamic> deliverables,
    required String timelineIsoDate,
  }) async {
    await _client.postJson(
      '/offers/$offerId/proposals',
      body: {
        'offer': offerId,
        'pitch': pitch,
        'deliverables': deliverables,
        'timeline': timelineIsoDate,
      },
    );
  }

  Future<void> counterProposal({
    required String proposalId,
    required Map<String, dynamic> deliverables,
    required String timelineIsoDate,
    String? note,
  }) async {
    await _client.postJson(
      '/proposals/$proposalId/counter',
      body: {
        'deliverables': deliverables,
        'timeline': timelineIsoDate,
        if (note != null) 'note': note,
      },
    );
  }

  Future<void> acceptProposal(String proposalId) async {
    await _client.postJson('/proposals/$proposalId/accept');
  }

  Future<void> declineProposal(String proposalId) async {
    await _client.postJson('/proposals/$proposalId/decline');
  }
}
